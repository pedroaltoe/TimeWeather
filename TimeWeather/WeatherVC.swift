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
    
    //MARK: - Properties
    
    
    private let currentWeather = CurrentWeather()
    private let locationManager = CLLocationManager()
    private var forecasts: [Forecast] = []
    private var refreshControl = UIRefreshControl()
     
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomView.layer.cornerRadius = 10
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startMonitoringSignificantLocationChanges()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        self.tableView.addSubview(self.refreshControl)
    }
    
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    
    
    // MARK: - IBAction
    
    

    
    
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
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            self.currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                    self.refreshControl.endRefreshing()
                }
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
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.locationManager.startUpdatingLocation()
    }

    private var forecastRequest: (token: DataRequest, handler: DownloadComplete?)? = nil
    private func downloadForecastData(completed: @escaping DownloadComplete) {
        self.forecastRequest?.token.cancel()
        self.forecastRequest = nil
        let token = Alamofire.request(FORECAST_URL).responseJSON { [weak self] response in
            guard let sSelf = self else { return }
            let result = response.result
            sSelf.forecasts.removeAll()
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        sSelf.forecasts.append(forecast)
                    }
                    sSelf.forecasts.removeFirst() //self.forecasts.remove(at: 0)
                    sSelf.tableView.reloadData()
                }
            }
            sSelf.forecastRequest?.handler?()
        }
        self.forecastRequest = (token, completed)
    }
    
    
    private func updateMainUI() {
        self.dateLabel.text = self.currentWeather.date
        self.currentTempLabel.text = self.currentWeather.currentTemp + "°"
        self.locationLabel.text = NSLocalizedString(self.currentWeather.cityName.uppercased() + ", " + self.currentWeather.countryName, comment: "Internationalizing the city and country name")
        self.currentWeatherTypeLabel.text = NSLocalizedString(self.currentWeather.weatherType.uppercased(), comment: "Weather type")
        
        switch self.currentWeatherTypeLabel.text! {
        case "Drizzle":
            self.currentWeatherImage.image = UIImage(named: "Rain-ImgV")
        case "Fog":
            self.currentWeatherImage.image = UIImage(named: "Mist-ImgV")
        case "Haze":
            self.currentWeatherImage.image = UIImage(named: "Mist-ImgV")
        default:
            self.currentWeatherImage.image = UIImage(named: self.currentWeather.weatherType + "-ImgV")
        }
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




















