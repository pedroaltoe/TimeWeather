//
//  WeatherCell.swift
//  rainyshinycloudy
//
//  Created by Pedro Altoe Costa on 31/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    var currentWeather = CurrentWeather()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    
    func configureCell(forecast: Forecast) {
        
        self.weatherTypeLabel.text = NSLocalizedString(forecast.weatherType, comment: "Weather type").uppercased()
        self.weatherIcon.image = UIImage(named: forecast.weatherType)
        self.dayLabel.text = self.dateToString(forecast.date).capitalized
        self.highTempLabel.text = forecast.highTemp + "°"
        self.lowTempLabel.text = forecast.lowTemp + "°"
        
        switch self.weatherTypeLabel.text! {
        case "DRIZZLE":
            self.weatherIcon.image = UIImage(named: "Rain-ImgV")
        case "FOG":
            self.weatherIcon.image = UIImage(named: "Mist-ImgV")
        case "Haze":
            self.weatherIcon.image = UIImage(named: "Mist-ImgV")
        default:
            self.weatherIcon.image = UIImage(named: forecast.weatherType + "-For")
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    private func dateToString(_ date: Date) -> String {
        let calendar = Calendar.current
        let sameDate = calendar.isDate(date, inSameDayAs: Date())
        let today = ( sameDate ? NSLocalizedString("Today", comment: "Today translation") : nil ) ?? String(self.dateFormatter.string(from: date))
        return today
    }
    
    public static let identifier = "WeatherCell"
}
