//
//  WeatherAPI+WeatherDetails.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 8/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import Foundation

extension WeatherDetails {
    
    init?(json: [String: Any]) {
        
        let pressure = json[Keys.pressure] as? Double
        self.pressure = pressure.flatMap({ String(Int($0)) }) ?? "--"
        
        let humidity = json[Keys.humidity] as? Double
        self.humidity = humidity.flatMap({ String(Int($0)) }) ?? "--"
        
        let windSpeed = json[Keys.windSpeed] as? Double
        self.windSpeed = windSpeed.flatMap({ String(Int($0 * 3.6)) }) ?? "--"
        
        let windDirection = json[Keys.windDirection] as? Double
        self.windDirection = windDirection.flatMap({ String(Int($0)) }) ?? "--"
    }
    
    
    // MARK: - Private stuff
    
    private enum Keys {
        static let pressure = "pressure"
        static let humidity = "humidity"
        static let windSpeed = "windSpeed"
        static let windDirection = "windDirection"
    }
    
}
