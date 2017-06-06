//
//  CurrentWeather.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 27/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import Foundation
import Alamofire

struct CurrentWeather {
    let cityName: String
    let countryName: String
    let date: Date
    let weatherType: String
    let currentTemp: String
    
    init(cityName: String = "", countryName: String = "", date: Date = Date(), weatherType: String = "", currentTemp: String = "--") {
        self.cityName = cityName
        self.countryName = countryName
        self.date = date
        self.weatherType = weatherType
        self.currentTemp = currentTemp
    }
}
