//
//  WeatherDetailsVC.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class WeatherDetailsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoDays.currentWeather = self.currentWeather
        self.infoDays.forecast = self.weatherDetails
        self.detailsDayVC.detailsDay = self.weatherDetails
    }   
    
    var weatherDetails = Forecast()
    var currentWeather = CurrentWeather()
    
    
    // MARK - Properties
    
    private lazy var infoDays: TodaysVC = {
        return self.childViewControllers.filter({ $0 is TodaysVC }).first as! TodaysVC
    }()
    private lazy var detailsDayVC: DetailsDayVC = {
        return self.childViewControllers.filter({ $0 is DetailsDayVC }).first as! DetailsDayVC
    }()
}
