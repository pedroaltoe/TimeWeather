//
//  TodaysVC.swift
//  
//
//  Created by Pedro Altoe Costa on 23/2/17.
//
//

import UIKit

class TodaysVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadData()
    }
    
    
    // MARK: - Private stuff
    
    private func reloadData() {
        guard self.isViewLoaded else { return }
        
        self.dateLabel.text = self.dateToString(self.currentWeather.date)
        self.currentTempLabel.text = self.currentWeather.currentTemp + "°"
        self.minTempLabel.text = self.forecast.lowTemp + "°"
        self.locationLabel.text = NSLocalizedString(self.currentWeather.cityName.uppercased() + ", " + self.currentWeather.countryName, comment: "Internationalizing the city and country name")
        self.currentWeatherTypeLabel.text = NSLocalizedString(self.currentWeather.weatherType, comment: "Weather Type").uppercased()
        switch self.currentWeatherTypeLabel.text! {
        case "DRIZZLE", "CHUVA":
            self.currentWeatherImage.image = UIImage(named: "Rain-ImgV")
        case "FOG", "NÉVOA":
            self.currentWeatherImage.image = UIImage(named: "Mist-ImgV")
        case "HAZE":
            self.currentWeatherImage.image = UIImage(named: "Mist-ImgV")
        default:
            self.currentWeatherImage.image = UIImage(named: self.currentWeather.weatherType + "-ImgV")
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    private func dateToString(_ date: Date) -> String {
        let calendar = Calendar.current
        let sameDate = calendar.isDate(date, inSameDayAs: Date())
        let today = ( sameDate ? NSLocalizedString("Today", comment: "Today translation") : nil ) ?? ""
        let dateString = [today, String(self.dateFormatter.string(from: date))].filter({ !$0.isEmpty }).joined(separator: ", ")
        
        return dateString
    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    // MARK: - Public stuff

    var forecast = Forecast() {
        didSet {
            self.reloadData()
        }
    }
    
    var currentWeather = CurrentWeather() {
        didSet {
            self.reloadData()
        }
    }
}
