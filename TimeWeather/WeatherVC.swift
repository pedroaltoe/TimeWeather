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

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var currentWeather = CurrentWeather()
    var forecasts = [Forecast]()
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.forecasts.removeAll()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startMonitoringSignificantLocationChanges()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func refreshData(_ sender: UIButton) {
        self.forecasts.removeAll()
        self.tableView.reloadData()
        self.locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    
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
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            self.currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                }
                self.forecasts.removeFirst() //self.forecasts.remove(at: 0)
                self.tableView.reloadData()
            }
        }
        completed()
    }


    func updateMainUI() {
        self.dateLabel.text = self.currentWeather.date
        self.currentTempLabel.text = self.currentWeather.currentTemp + "°"
        self.locationLabel.text = self.currentWeather.cityName + ", " + self.currentWeather.countryName
        self.currentWeatherTypeLabel.text = self.currentWeather.weatherType
        self.currentWeatherImage.image = UIImage(named: self.currentWeather.weatherType)
    }
    
    
    // MARK: - TableViewDataSource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WeatherCell {
            let forecast = self.forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            
            return cell
            
        } else {
            return WeatherCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let forecast = self.forecasts[indexPath.row]
//        
//        performSegue(withIdentifier: "detailsVC", sender: forecast)
//    }
//    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        //TODO prepare data to send to detailsVC as in Forecast class
//    }
    
}




















