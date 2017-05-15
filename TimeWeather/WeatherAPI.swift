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
        let id = arc4random()
        let detailsRequest: DataRequest
        let forecastRequest: DataRequest
        let handler: WeatherReportCompletionHandler
        
        func cancel() {
            self.detailsRequest.cancel()
            self.forecastRequest.cancel()
        }
    }
    
    private static var requestToken: Request?
    
    private static var searchVC: SearchVC?

    static func fetchWeatherReport(for coordinate: CLLocationCoordinate2D, completed: @escaping WeatherReportCompletionHandler) {
        self.requestToken?.cancel()
        self.requestToken = nil

        let group = DispatchGroup()
        
        var currentWeather = CurrentWeather()
        var forecasts: [Forecast] = []
        var todaysVC = TodaysVC()
        
        
        
        group.enter()
        let detailsUrl: WeatherData = .detailsLocation(coordinates: coordinate)
        let detailsRequest = Alamofire.request(detailsUrl).responseJSON { response in
            DispatchQueue.global(qos: .default).async {
                defer { group.leave() }
                let result = response.result
                if let json = result.value as? [String: Any] {
                    currentWeather = CurrentWeather(json: json) ?? currentWeather
                }
            }
        }

        group.enter()
        let forecastUrl: WeatherData = .forecastLocation(coordinates: coordinate)
        let forecastRequest = Alamofire.request(forecastUrl).responseJSON { response in
            DispatchQueue.global(qos: .default).async {
                defer { group.leave() }
                let result = response.result
                if let dict = result.value as? [String: Any],
                    let list = dict["list"] as? [[String: Any]] {
                    forecasts = Array(list
                        .flatMap({ Forecast(json: $0) }))
                }
            }
        }
        
        let requestToken = Request(detailsRequest: detailsRequest, forecastRequest: forecastRequest, handler: completed)
        self.requestToken = requestToken
        
        group.notify(queue: DispatchQueue.main) {
            guard let rq = self.requestToken,
                rq.id == requestToken.id,
                requestToken.detailsRequest.task?.state == .completed else { return }
            defer { self.requestToken = nil }
            self.requestToken?.handler(WeatherReport(currentWeather: currentWeather, forecasts: forecasts))
        }
    }
}

private enum WeatherData {
    case search(cityName: String)
    case detailsLocation(coordinates: CLLocationCoordinate2D)
    case forecastLocation(coordinates: CLLocationCoordinate2D)
}

extension WeatherData: URLConvertible {
    
    func asURL() throws -> URL {
        
        let baseUrl = "http://api.openweathermap.org/data/2.5"
        let appid = "ff27f55b14ac026738922f15b9ce708d"
        
        switch self {
        case let .search(cityName):
            return URL(string: baseUrl + "/weather?q=\(cityName)&appid=" + appid)!
        case let .forecastLocation(coordinates):
            return URL(string: baseUrl + "/forecast/daily?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&cnt=10&appid=" + appid)!
        case let .detailsLocation(coordinates):
            return URL(string: baseUrl + "/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=" + appid)!
        }
    }
}

extension WeatherAPI {
    
    private var baseUrl: String { return "http://api.openweathermap.org/data/2.5" }
    private var appid: String { return "ff27f55b14ac026738922f15b9ce708d" }
    
    private var cityName: String { return "" }
    
    var searchDetailsUrl: String {
        let url = self.baseUrl + "/weather?q=\(cityName)&appid=" + self.appid
        return url
    }
}
