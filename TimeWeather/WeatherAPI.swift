//
//  TimeWeatherAPI.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 1/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import Foundation
import CoreLocation

import Alamofire

typealias WeatherReportCompletionHandler = (WeatherReport) -> Void


enum WeatherAPI {
    
    private struct Request {
        let detailsRequest: DataRequest
        let forecastRequest: DataRequest
        let handler: WeatherReportCompletionHandler
        
        func cancel() {
            self.detailsRequest.cancel()
            self.forecastRequest.cancel()
        }
    }
    
    private static var requestToken: Request?

    static func fetchWeatherReport(for coordinate: CLLocationCoordinate2D, completed: @escaping WeatherReportCompletionHandler) {
        self.requestToken?.cancel()
        self.requestToken = nil

        let group = DispatchGroup()
        
        var currentWeather = CurrentWeather()
        var forecasts: [Forecast] = []
        
        group.enter()
        let detailsRequest = Alamofire.request(coordinate.detailsUrl).responseJSON { response in
            DispatchQueue.global(qos: .default).async {
                defer { group.leave() }
                let result = response.result
                if let json = result.value as? [String: Any] {
                    currentWeather = CurrentWeather(json: json) ?? currentWeather
                }
            }
        }

        group.enter()
        let forecastRequest = Alamofire.request(coordinate.forecastUrl).responseJSON { response in
            DispatchQueue.global(qos: .default).async {
                defer { group.leave() }
                let result = response.result
                if let dict = result.value as? [String: Any],
                    let list = dict["list"] as? [[String: Any]] {
                    forecasts = Array(list
                        .flatMap({ Forecast(json: $0) })
                        .dropFirst())
                }
            }
        }
        self.requestToken = Request(detailsRequest: detailsRequest, forecastRequest: forecastRequest, handler: completed)
        
        group.notify(queue: DispatchQueue.main) {
            defer { self.requestToken = nil }
            guard self.requestToken?.detailsRequest.task?.state == .completed else { return }
            self.requestToken?.handler(WeatherReport(currentWeather: currentWeather, forecasts: forecasts))
        }
    }

}


fileprivate extension CLLocationCoordinate2D {
    
    private var baseUrl: String { return "http://api.openweathermap.org/data/2.5" }
    private var appid: String { return "ff27f55b14ac026738922f15b9ce708d" }
    
    var forecastUrl: String {
        let url = self.baseUrl + "/forecast/daily?lat=\(self.latitude)&lon=\(self.longitude)&cnt=10&mode=json&appid=" + self.appid
        return url
    }
    
    var detailsUrl: String {
        let url = self.baseUrl + "/weather?lat=\(self.latitude)&lon=\(self.longitude)&appid=" + self.appid
        return url
    }
}
