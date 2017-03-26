//
//  Forecast.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 30/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import Foundation
import Alamofire

struct Forecast {
    
    let date: Date
    let weatherType: String
    let highTemp: String
    let lowTemp: String
    let pressure: String
    let humidity: String
    let windSpeed: String
    let windDirection: String

    
    init(date: Date = Date(), weatherType: String = "", highTemp: String = "--", lowTemp: String = "--", pressure: String = "--", humidity: String = "--", windSpeed: String = "--", windDirection: String = "--") {
        
        self.date = date
        self.weatherType = weatherType
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }
}

























