//
//  WeatherDetails.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 8/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import Foundation

struct WeatherDetails {
    
    let pressure: String
    let humidity: String
    let windSpeed: String
    let windDirection: String
    
    init(pressure: String = "--", humidity: String = "--", windSpeed: String = "--", windDirection: String = "") {
        
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }
}
