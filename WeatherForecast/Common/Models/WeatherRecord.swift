//
//  WeatherRecord.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 22/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import Foundation

// Represents Weather Forecast data

class WeatherRecord {
    var locationName: String?
    var date: NSDate?
    var temperature: Double?
    var minTemperature: Double?
    var maxTemperature: Double?
    var weatherId: Int?
    var describedAs: String?
    
    init(dictionary: [String: AnyObject]) {
        // TODO: - Trade-off : need refactoring of  JSON parsing out from the transparent Model classs
        guard let dateTimeString = dictionary["dt_txt"] as? String else {
            return
        }
        
        guard let mainInfo = dictionary["main"] as? [String: AnyObject],
            let temperature = mainInfo["temp"] as? Double,
            let minTemperature = mainInfo["temp_min"] as? Double,
            let maxTemperature = mainInfo["temp_max"] as? Double else {
                return
        }
        
        guard let weatherArray = dictionary["weather"] as? [AnyObject],
            let weatherInfo = weatherArray[0] as? [String: AnyObject],
            let weatherId = weatherInfo["id"] as? Int,
            let description = weatherInfo["description"] as? String else {
                return
        }
        
        self.date = dateTimeString.defautFormattedDate()
        self.temperature = temperature
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.weatherId = weatherId
        self.describedAs = description
    }
}
