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
        case "HAZE", "NÉVOA":
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
        let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
        let today = components.day.flatMap({ $0 == 0 ? NSLocalizedString("Today", comment: "Today translation") : nil }) ?? ""
        let dateString = [today, String(self.dateFormatter.string(from: date))].filter({ !$0.isEmpty }).joined(separator: ", ")
        
        return dateString
    }
    
    
    // MARK: - Public stuff
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

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
