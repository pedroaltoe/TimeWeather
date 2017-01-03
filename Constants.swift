//
//  Constants.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 27/12/16.
//  Copyright © 2016 Pedro Altoe Costa. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "ff27f55b14ac026738922f15b9ce708d"

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)-33.9667\(LONGITUDE)151.1\(APP_ID)\(API_KEY)"

let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=-33.9667&lon=151.1&cnt=10&mode=json&appid=ff27f55b14ac026738922f15b9ce708d"

typealias DownloadComplete = () -> ()



