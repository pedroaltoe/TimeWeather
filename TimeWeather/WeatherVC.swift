//
//  ViewController.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 27/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import UIKit
import Alamofire

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentWeather = CurrentWeather()
//    var forecast = Forecast()
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.currentWeather.downloadWeatherDetails {
            self.downloadForecastData {
                self.updateMainUI()
            }
        }
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.removeFirst() //self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    
    func updateMainUI() {
        self.dateLabel.text = self.currentWeather.date
        self.currentTempLabel.text = self.currentWeather.currentTemp + "°"
        self.locationLabel.text = self.currentWeather.cityName + ", " + self.currentWeather.countryName
        self.currentWeatherTypeLabel.text = self.currentWeather.weatherType
        self.currentWeatherImage.image = UIImage(named: self.currentWeather.weatherType)
    }
    
    
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
    
}

