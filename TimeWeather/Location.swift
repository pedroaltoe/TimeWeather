//
//  Location.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 3/1/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
