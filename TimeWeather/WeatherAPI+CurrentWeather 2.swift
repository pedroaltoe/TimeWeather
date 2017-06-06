//
//  WeatherAPI+CurrentWeather.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 1/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import Foundation



extension CurrentWeather {
    
    init?(json: [String: Any]) {
        self.cityName = ((json[Keys.name] as? String) ?? "").capitalized
        
        let weather = json[Keys.weather] as? [[String: Any]]
        self.weatherType = ((weather?.first?[Keys.main] as? String) ?? "").capitalized
        
        let main =  json[Keys.main] as? [String: Any]
        let temp = main?[Keys.temp] as? Double
        self.currentTemp = temp.flatMap({ String(Int($0 - 273.15)) }) ?? "--"
        
        let sys = json[Keys.sys] as? [String: Any]
        self.countryName = ((sys?[Keys.country] as? String) ?? "").uppercased()
        
        guard let timestamp = json[Keys.timestamp] as? TimeInterval else { return nil }
        self.date = Date(timeIntervalSince1970: timestamp)
    }
    
    
    // MARK: - Private stuff
    
    private enum Keys {
        static let name = "name"
        static let weather = "weather"
        static let main = "main"
        static let temp = "temp"
        static let sys = "sys"
        static let country = "country"
        static let timestamp = "dt"
    }

}
