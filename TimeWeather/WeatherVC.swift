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
        if let currentLocation = locations.last {
            self.downloadWeatherDetails(coordinate: currentLocation.coordinate) {
                self.downloadForecastData(coordinate: currentLocation.coordinate) {}
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        switch error {
        case CLError.network, CLError.locationUnknown:
            let networkIssueAlert = UIAlertController(title: "Network Error", message: "Please connect to the internet to get latest weather data", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: {
                action in self.locationManager.startUpdatingLocation()})
            networkIssueAlert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            networkIssueAlert.addAction(cancelButton)
            self.present(networkIssueAlert, animated: true, completion: nil)
            break
        default: print("Error!")
            break
        }
    }
    
    
    // MARK: - Private Functions
    
    @objc
    private func didPullToRefresh(control: UIRefreshControl) {
        self.locationManager.startUpdatingLocation()
    }
    
    private func downloadWeatherDetails(coordinate: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
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
    
    private func downloadForecastData(coordinate: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        self.nextDays.refreshControl?.beginRefreshing()
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
            sSelf.nextDays.refreshControl?.endRefreshing()
            sSelf.forecastRequest?.handler?()
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
