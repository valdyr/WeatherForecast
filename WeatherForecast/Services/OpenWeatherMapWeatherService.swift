//
//  OpenWeatherMapWeatherService.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 22/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import UIKit

/*
 * Concrete implementation of the Weather Service Provider, based on Open Weather Map
 *
 */
class OpenWeatherMapWeatherService: WeatherServiceProvider {

    // MARK: - Constants
    let baseURL = "http://api.openweathermap.org/data/2.5/forecast"
    let appId = "f5b834d62ca05892e10ce011a51f3f48"
    
    // TODO: - Fix hard-coded city ID = 2643743 (London)
    let defaultCityId = 2643743
    
    // MARK: - WeatherServiceProvider protocol implementation
    func requestWeatherForecast(searchTerm: WeatherSearchTerm?, completion: WeatherServiceCompletion) {
        
        let requestURL: NSURL?
        let term = searchTerm ?? WeatherSearchTerm.byCityID(defaultCityId)
        
        switch term {
        case .byCityID(let cityID):
            let URLString = baseURL + "?id=" + String(cityID) + "&units=metric&appid=" + appId
            requestURL = NSURL(string: URLString)
        default:
            fatalError("\(searchTerm) not supported yet!")
        }
        
        if let url = requestURL {
            self.requestResourceWithURL(url, completion: completion)
        } else {
            completion(nil, .badURL)
        }
    }
    
    func requestResourceWithURL(url: NSURL, completion: WeatherServiceCompletion) {
    // TODO: - Should be refactored to split 2 responsibilities: requesting network data and parsing JSON response/creating data objects (may use 3rd party libraries to simplify code).
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            
            // Check for any networking errors
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil, .networkRequestFailed)
                })
            }
            
            do {
                if let unwrappedData = data {
                
                    let jsonDicts = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers) as? [String: AnyObject]
                    
                    guard let cityInfo = jsonDicts?["city"] as? [String: AnyObject],
                        let locationName = cityInfo["name"] as? String else {
                        throw WeatherServiceError.jsonParsingFailed
                    }
                    
                    guard let forecasts = jsonDicts?["list"] as? [[String: AnyObject]] else {
                        throw WeatherServiceError.jsonParsingFailed
                    }
                    
                    let records = forecasts.map({ (dict: [String: AnyObject]) -> WeatherRecord in
                        
                        let record = WeatherRecord(dictionary: dict)
                        record.locationName = locationName
                        return record
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(records, nil)
                    })
                    
                } else {
                    throw WeatherServiceError.jsonParsingFailed
                }
                
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil, .jsonParsingFailed)
                })
            }
            
        }.resume()
    }
}
