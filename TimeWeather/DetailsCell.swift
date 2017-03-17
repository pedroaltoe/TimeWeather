//
//  DetailsCell.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 16/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    
    func configureDetailsDayCell(weatherDetails: WeatherDetails) {
        
        switch self.titleLabel.text! {
        case weatherDetails.pressure:
            self.valueLabel.text = NSLocalizedString(weatherDetails.pressure + "hPa", comment: "Pressure Value in Hectopascal").uppercased()
        case weatherDetails.humidity:
            self.valueLabel.text = NSLocalizedString(weatherDetails.humidity + "%", comment: "Humidity Percentage").uppercased()
        case weatherDetails.windSpeed:
            self.valueLabel.text = NSLocalizedString(weatherDetails.windSpeed + "Km/h", comment: "Wind Speed").uppercased()
        case weatherDetails.windDirection:
            if let windDirection = Double(weatherDetails.windDirection) {
                
                switch windDirection {
                case 348.75..<11.25:
                    self.titleLabel.text = "N"
                case 11.25..<33.75:
                    self.titleLabel.text = "NNE"
                case 33.75..<56.25:
                    self.titleLabel.text = "NE"
                case 56.25..<78.75:
                    self.titleLabel.text = "ENE"
                case 78.75..<101.25:
                    self.titleLabel.text = "E"
                case 101.25..<123.75:
                    self.titleLabel.text = "ESE"
                case 123.75..<146.25:
                    self.titleLabel.text = "SE"
                case 146.25..<168.75:
                    self.titleLabel.text = "SSE"
                case 168.75..<191.25:
                    self.titleLabel.text = "S"
                case 191.25..<213.75:
                    self.titleLabel.text = "SSW"
                case 213.75..<236.25:
                    self.titleLabel.text = "SW"
                case 236.25..<258.75:
                    self.titleLabel.text = "WSW"
                case 258.75..<281.25:
                    self.titleLabel.text = "W"
                case 281.25..<303.75:
                    self.titleLabel.text = "WNW"
                case 303.75..<326.25:
                    self.titleLabel.text = "NW"
                case 326.25..<348.75:
                    self.titleLabel.text = "NNW"
                default: print("Wind Direction Error")
                }
            }
        default:
            print("Error")
        }
    }
    public static let identifier = "DetailsCell"
}
