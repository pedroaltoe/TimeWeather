//
//  LocationAPI.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/5/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//


import Foundation
import Alamofire

typealias LocationSearchCompletionHandler = ([Location]) -> Void

enum LocationAPI {
    
    static func searchLocation(query: String, completed: @escaping LocationSearchCompletionHandler) {
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + query + "&types=geocode&key=AIzaSyDkx36UWOQp3NEBdZOVq6qizvy7gDbxuDY"
        var request: DataRequest? = nil
        request = Alamofire.request(urlString).responseJSON { response in
            DispatchQueue.global(qos: .default).async {
                defer { request = nil }
                
                let result = response.result
                
                var locations: [Location] = []
                defer { completed(locations) }
                guard let json = result.value as? [String: Any],
                let predictions = json["predictions"] as? [[String: Any]] else { return }
                locations = predictions.flatMap({ Location(json: $0) })
            }
        }
    }
}
