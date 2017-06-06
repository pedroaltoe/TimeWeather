//
//  WeatherAPI+Forecast.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 1/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import Foundation


extension Forecast {

    init?(json: [String: Any]) {
        
        let temp = json[Keys.temp] as? [String: Any]
        let min = temp?[Keys.min] as? Double
        self.lowTemp = min.flatMap({ String(Int(round($0 - 273.15))) }) ?? "--"
        
        let max = temp?[Keys.max] as? Double
        self.highTemp = max.flatMap({ String(Int(round($0 - 273.15))) }) ?? "--"
        
        let weather = json[Keys.weather] as? [[String: Any]]
        self.weatherType = ((weather?.first?[Keys.main] as? String) ?? "").capitalized
        
        let pressure = json[Keys.pressure] as? Double
        self.pressure = pressure.flatMap({ String(Int(round($0))) }) ?? "--"
        
        let humidity = json[Keys.humidity] as? Double
        self.humidity = humidity.flatMap({ String(Int(round($0))) }) ?? "--"
        
        let windSpeed = json[Keys.windSpeed] as? Double
        self.windSpeed = windSpeed.flatMap({ String(Int(round($0 * 3.6))) }) ?? "--"
        
        let windDirection = json[Keys.windDirection] as? Double
        self.windDirection = windDirection.flatMap({ String(Int(round($0))) }) ?? "--"
        
        guard let timestamp = json[Keys.timestamp] as? TimeInterval else { return nil }
        self.date = Date(timeIntervalSince1970: timestamp)
    }
    
    
    // MARK: - Private stuff
    
    private enum Keys {
        static let temp = "temp"
        static let min = "min"
        static let max = "max"
        static let weather = "weather"
        static let main = "main"
        static let pressure = "pressure"
        static let humidity = "humidity"
        static let windSpeed = "speed"
        static let windDirection = "deg"
        static let timestamp = "dt"
    }
}
