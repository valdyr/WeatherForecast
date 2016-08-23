//
//  WeatherServiceProvider.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 22/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import UIKit
import CoreLocation

/* Should've used apple doc or doxygen documentation style ;)
 * 
 * Definition of the generic interface for the abstract Weather Service:
 * should simplify mocking for unit tests and allow adopting another Weather API Provider
 *
 */

// Arguments, which Weather Service may accept (currently heavily based on OpenWeatherMap API)
enum WeatherSearchTerm {
    case byCityName(String)
    case byCityID(Int)
    case byGeographicLocation(CLLocationCoordinate2D)
}

// Errors, returned by Weather Service
enum WeatherServiceError: ErrorType {
    case networkRequestFailed
    case jsonParsingFailed
    case badURL
    // TODO: Extend with all potential errors, expected from the service
}

// Generic API completion block alias
typealias WeatherServiceCompletion = ([WeatherRecord]?, WeatherServiceError?) -> Void

// API definition for a Weather Service
protocol WeatherServiceProvider {
    func requestWeatherForecast(searchTerm: WeatherSearchTerm?, completion: WeatherServiceCompletion) -> Void
    // TODO: Should be easy to extend, if required in the future
}
