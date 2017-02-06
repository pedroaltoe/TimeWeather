//
//  Forecast.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 30/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import Foundation
import Alamofire

class Forecast {
    
    private var _date: String!
    private var _weatherType: String!
    private var _highTemp: String!
    private var _lowTemp: String!
    
//    var _longitude: String!
//    var _latitude: String!
//    var _pressure: Int!
//    var _humidity:Int!
//    var _windSpeed:Int!
//    var _sunrise: String!
//    var _sunset:String!
    
    
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
            self._date = unixConvertedDate.dateOfTheWeek().capitalized
        }
    }
    
    
//    func downloadForecastData(completed: @escaping DownloadComplete) {
//        Alamofire.request(FORECAST_URL).responseJSON { response in
//            let result = response.result
//            
//            if let dict = result.value as? Dictionary<String, AnyObject> {
//                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
//                    for obj in list {
//                        for i in 0...list.count {
//                            if let temp = obj["temp"] as? Dictionary<String, AnyObject> {
//                                if let min = temp["min"] as? Double {
//                                    let kelvinTocelsiusTemp = Int(min - 273.15)
//                                    self._lowTemp = String(kelvinTocelsiusTemp)
//                                    self.forecasts[i][0] = self._lowTemp
//                                    
//                                }
//                                if let max = temp["max"] as? Double {
//                                    let kelvinTocelsiusTemp = Int(max - 273.15)
//                                    self._highTemp = String(kelvinTocelsiusTemp)
//                                    self.forecasts[i][1] = self._highTemp
//                                }
//                            }
//                            if let weather = obj["weather"] as? [Dictionary<String, AnyObject>] {
//                                if let main = weather[0]["main"] as? String {
//                                    self._weatherType = main
//                                    self.forecasts[i][2] = self._weatherType
//                                }
//                            }
//                            if let date = obj["dt"] as? Double {
//                                let unixConvertedDate = Date(timeIntervalSince1970: date)
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateStyle = .full
//                                dateFormatter.timeStyle = .none
//                                self._date = unixConvertedDate.dateOfTheWeek()
//                                self.forecasts[i][3] = self._date
//                            }
//                        }
//                    }
//                }
//            }
//            self.forecasts.removeFirst() //self.forecasts.remove(at: 0)
//            self.weatherVC.tableView.reloadData()
//        }
//        completed()
//    }
}

extension Date {
    func dateOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

























