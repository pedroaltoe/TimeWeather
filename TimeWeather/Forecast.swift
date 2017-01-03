//
//  Forecast.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 30/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if self._date == nil {
            self._date = ""
        }
        return self._date
    }
    
    var weatherType: String {
        if self._weatherType == nil {
            self._weatherType = ""
        }
        return self._weatherType
    }
    
    var highTemp: String {
        if self._highTemp == nil {
            self._highTemp = ""
        }
        return self._highTemp
    }
    
    var lowTemp: String {
        if self._lowTemp == nil {
            self._lowTemp = ""
        }
        return self._lowTemp
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                let kelvinTocelsiusTemp = Int(min - 273.15)
                self._lowTemp = String(kelvinTocelsiusTemp)
                
            }
            if let max = temp["max"] as? Double {
                let kelvinTocelsiusTemp = Int(max - 273.15)
                self._highTemp = String(kelvinTocelsiusTemp)
            }
        }
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dateOfTheWeek()
        }
    }
}

extension Date {
    func dateOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}























