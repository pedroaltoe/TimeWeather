//
//  WeatherVC.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 27/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

protocol WeatherVCDelegate {
    func toggleRightPanel()
}


class WeatherVC: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        self.nextDays.refreshControl = refreshControl
        self.nextDays.refreshControl?.addTarget(self, action: #selector(type(of: self).didPullToRefresh(control:)), for: .valueChanged)
        self.nextDays.refreshControl?.beginRefreshing()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        self.didPullToRefresh(control: refreshControl)
        
        self.nextDays.delegate = self
        
        self.todays.minTempLabel.isHidden = true
        
    }
    
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    fileprivate lazy var todays: TodaysVC = {
        return self.children.filter({ $0 is TodaysVC }).first as! TodaysVC
    }()
    private lazy var nextDays: NextDaysVC = {
        return self.children.filter({ $0 is NextDaysVC }).first as! NextDaysVC
    }()
    
    var location: Location? = nil {
        didSet {
            self.fetchWeatherForecast()
        }
    }
    
    var delegate: WeatherVCDelegate?
    
    
    // MARK: - CLLocationManager
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status){
        case .notDetermined: self.locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse: self.locationManager.startUpdatingLocation()
            break
        default: print("DEFAULT", status.rawValue)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
            CLLocationCoordinate2DIsValid(location.coordinate) else { return }
        self.locationManager.stopUpdatingLocation()
        if let currentLocation = self.currentLocation,
            currentLocation.timestamp > location.timestamp {
            self.nextDays.refreshControl?.endRefreshing()
            return
        }
        self.currentLocation = location
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch error {
        case CLError.network, CLError.locationUnknown:
            self.locationManager.stopUpdatingLocation()
            let networkIssueAlert = UIAlertController(title: "Network Error", message: "Unable to get latest weather data", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in self.locationManager.startUpdatingLocation()})
            networkIssueAlert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            networkIssueAlert.addAction(cancelButton)
            self.present(networkIssueAlert, animated: true, completion: nil)
            break
        default: print("Error! \(error.localizedDescription)")
            break
        }
    }
    
    
    // MARK: - Private Functions
    
    private var currentLocation: CLLocation? = nil {
        didSet {
            guard self.currentLocation != nil else {
                self.nextDays.refreshControl?.endRefreshing()
                return
            }
            self.scheduleFetchWeatherForecast()
        }
    }
    
    private var coordinate: CLLocationCoordinate2D? {
        return self.currentLocation?.coordinate
    }
    
    private func scheduleFetchWeatherForecast() {
        let selector = #selector(type(of: self).fetchWeatherForecast)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
        self.perform(selector, with: coordinate, afterDelay: 1.0)
    }
    
    @objc
    private func fetchWeatherForecast() {
        let locationType: LocationType
        if let location = self.location {
            locationType = .name(location.mainText)
        } else {
            guard let coordinate = self.coordinate else { preconditionFailure() }
            locationType = .coordinate(coordinate)
        }
        self.nextDays.refreshControl?.beginRefreshing()

        WeatherAPI.fetchWeatherReport(for: locationType) { [weak self] report in
            self?.todays.currentWeather = report.currentWeather
            self?.nextDays.forecasts = report.forecasts
            self?.nextDays.refreshControl?.endRefreshing()
        }
    }
    
    @objc
    private func didPullToRefresh(control: UIRefreshControl) {
        if let _ = self.location {
            self.fetchWeatherForecast()
        } else {
            self.locationManager.startUpdatingLocation()
        }

    }

}


    // MARK: - NextDaysDelegate

extension WeatherVC: NextDaysVCDelegate {
    
    func didSelectForecast(forecast: Forecast) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherDetailsVC = storyboard.instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
        weatherDetailsVC.weatherDetails = forecast
        weatherDetailsVC.currentWeather = CurrentWeather(cityName: self.todays.currentWeather.cityName, countryName: self.todays.currentWeather.countryName, date: forecast.date, weatherType: forecast.weatherType, currentTemp: forecast.highTemp)
        self.navigationController?.pushViewController(weatherDetailsVC, animated: true)
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
}

extension UIImageView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
