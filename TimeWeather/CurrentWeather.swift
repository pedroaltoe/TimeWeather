//
//  CurrentWeather.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 27/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import Foundation
import Alamofire

class CurrentWeather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: String!
    private var _coutryName: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var countryName: String {
        if _coutryName == nil {
            _coutryName = ""
        }
        return _coutryName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        let currentDate = dateformatter.string(from: Date())
        _date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType : String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = "0.0"
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main =  dict["main"] as? Dictionary<String, AnyObject> {
                    if let temp = main["temp"] as? Double {
                        let kelvinTocelsiusTemp = Int(temp - 273.15)
                        self._currentTemp = String(kelvinTocelsiusTemp)
                    }
                }
                
                if let sys = dict["sys"] as? Dictionary<String, AnyObject> {
                    if let country = sys["country"] as? String{
                        self._coutryName = country.uppercased()
                    }
                }
            }
            completed()
        }
    }
}
