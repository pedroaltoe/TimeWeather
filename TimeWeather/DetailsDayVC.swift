//
//  DetailsDayVC.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class DetailsDayVC: UIViewController {
    
    var weatherDetails = WeatherDetails()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    
    func configureDetailsDayView() {
        self.pressureLabel.text = NSLocalizedString(self.weatherDetails.pressure + "hPa", comment: "Pressure Value in Hectopascal").uppercased()
        self.humidityLabel.text = NSLocalizedString(self.weatherDetails.humidity + "%", comment: "Humidity Percentage").uppercased()
        self.windSpeedLabel.text = NSLocalizedString(self.weatherDetails.windSpeed + "Km/h", comment: "Wind Speed").uppercased()
        
        if let windDirection = Double(self.weatherDetails.windDirection) {
            
            switch windDirection {
            case 348.75..<11.25:
                self.windDirectionLabel.text = "N"
            case 11.25..<33.75:
                self.windDirectionLabel.text = "NNE"
            case 33.75..<56.25:
                self.windDirectionLabel.text = "NE"
            case 56.25..<78.75:
                self.windDirectionLabel.text = "ENE"
            case 78.75..<101.25:
                self.windDirectionLabel.text = "E"
            case 101.25..<123.75:
                self.windDirectionLabel.text = "ESE"
            case 123.75..<146.25:
                self.windDirectionLabel.text = "SE"
            case 146.25..<168.75:
                self.windDirectionLabel.text = "SSE"
            case 168.75..<191.25:
                self.windDirectionLabel.text = "S"
            case 191.25..<213.75:
                self.windDirectionLabel.text = "SSW"
            case 213.75..<236.25:
                self.windDirectionLabel.text = "SW"
            case 236.25..<258.75:
                self.windDirectionLabel.text = "WSW"
            case 258.75..<281.25:
                self.windDirectionLabel.text = "W"
            case 281.25..<303.75:
                self.windDirectionLabel.text = "WNW"
            case 303.75..<326.25:
                self.windDirectionLabel.text = "NW"
            case 326.25..<348.75:
                self.windDirectionLabel.text = "NNW"
            default: print("Wind Direction Error")
            }
        }
    }
    
    public static let identifier = "DetailsDayVC"
}
