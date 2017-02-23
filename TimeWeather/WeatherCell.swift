//
//  WeatherCell.swift
//  rainyshinycloudy
//
//  Created by Pedro Altoe Costa on 31/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    
    func configureCell(forecast: Forecast) {
        self.weatherTypeLabel.text = NSLocalizedString(forecast.weatherType.uppercased() , comment: "Weather type")
        self.weatherIcon.image = UIImage(named: forecast.weatherType)
        self.dayLabel.text = forecast.date
        self.highTempLabel.text = forecast.highTemp + "°"
        self.lowTempLabel.text = forecast.lowTemp + "°"
        
        switch self.weatherTypeLabel.text! {
        case "Drizzle":
            self.weatherIcon.image = UIImage(named: "Rain-ImgV")
        case "Fog":
            self.weatherIcon.image = UIImage(named: "Mist-ImgV")
        case "Haze":
            self.weatherIcon.image = UIImage(named: "Mist-ImgV")
        default:
            self.weatherIcon.image = UIImage(named: forecast.weatherType + "-For")
        }
    }
    
    public static let identifier = "WeatherCell"
}
