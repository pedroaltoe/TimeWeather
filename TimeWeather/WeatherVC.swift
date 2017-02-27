//
//  ViewController.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 27/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var forecastRequest: (token: DataRequest, handler: DownloadComplete?)? = nil
    private lazy var todays: TodaysVC = {
        return self.childViewControllers.filter({ $0 is TodaysVC }).first as! TodaysVC
    }()
    private lazy var nextDays: NextDaysVC = {
        return self.childViewControllers.filter({ $0 is NextDaysVC }).first as! NextDaysVC
    }()
    
     

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todays.bottomView.layer.cornerRadius = 10

        self.nextDays.refreshControl = UIRefreshControl()
        self.nextDays.refreshControl?.addTarget(self, action: #selector(type(of: self).didPullToRefresh(control:)), for: .valueChanged)
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }

    
    
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
        self.locationManager.stopUpdatingLocation()
        print(">>>> Coordinates: \(locations.map({ $0.coordinate }))")
        if let location = locations.last,
            CLLocationCoordinate2DIsValid(location.coordinate) {
            if let currentLocation = self.currentLocation,
                currentLocation.timestamp > location.timestamp {
                self.nextDays.refreshControl?.endRefreshing()
                return
            }
            self.currentLocation = location
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch error {
        case CLError.network:
            self.locationManager.stopUpdatingLocation()
            let networkIssueAlert = UIAlertController(title: "Network Error", message: "Please connect to the internet to get latest weather data", preferredStyle: .alert)
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
        guard let coordinate = self.coordinate else { return }
        self.nextDays.refreshControl?.beginRefreshing()
        self.downloadWeatherDetails(for: coordinate) {
            self.downloadForecastData(for: coordinate) {
                self.nextDays.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc
    private func didPullToRefresh(control: UIRefreshControl) {
        self.locationManager.startUpdatingLocation()
    }
    
    private func downloadWeatherDetails(for coordinate: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        print("coordinate: \(coordinate)")
        Alamofire.request(coordinate.detailsUrl).responseJSON { response in
            let result = response.result
            
            var currentWeather = CurrentWeather()
            if let json = result.value as? [String: Any] {
                currentWeather = CurrentWeather(json: json) ?? currentWeather
            }
            self.todays.currentWeather = currentWeather
            completed()
        }
    }
    
    private func downloadForecastData(for coordinate: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        self.forecastRequest?.token.cancel()
        self.forecastRequest = nil
        let token = Alamofire.request(coordinate.forecastUrl).responseJSON { [weak self] response in
            guard let sSelf = self else { return }
            let result = response.result
            var forecasts: [Forecast] = []
            if let dict = result.value as? Dictionary<String, AnyObject>,
                let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                forecasts = Array(list
                    .map({ Forecast(weatherDict: $0) })
                    .dropFirst())
            }
            
            sSelf.nextDays.forecasts = forecasts
            sSelf.forecastRequest?.handler?()
            sSelf.forecastRequest = nil
        }
        self.forecastRequest = (token, completed)
    }
}


extension CurrentWeather {
    
    init?(json: [String: Any]) {
        self.cityName = ((json["name"] as? String) ?? "").capitalized
        
        let weather = json["weather"] as? [[String: Any]]
        self.weatherType = ((weather?.first?["main"] as? String) ?? "").capitalized
        
        let main =  json["main"] as? [String: Any]
        let temp = main?["temp"] as? Double
        self.currentTemp = temp.flatMap({ String(Int($0 - 273.15)) }) ?? "--"
        
        let sys = json["sys"] as? [String: Any]
        self.countryName = ((sys?["country"] as? String) ?? "").uppercased()
        
        guard let timestamp = json["dt"] as? TimeInterval else { return nil }
        self.date = Date(timeIntervalSince1970: timestamp)
    }
    
}


extension CLLocationCoordinate2D {
    
    var forecastUrl: String {
        let url = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(self.latitude)&lon=\(self.longitude)&cnt=10&mode=json&appid=ff27f55b14ac026738922f15b9ce708d"
        return url
    }
    
    var detailsUrl: String {
        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude)&lon=\(self.longitude)&appid=ff27f55b14ac026738922f15b9ce708d"
        return url
    }
}
