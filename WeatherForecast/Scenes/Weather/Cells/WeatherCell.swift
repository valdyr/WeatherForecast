//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 22/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {

    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configureCell(indexPath: NSIndexPath, record: WeatherRecord) {
        
        if let date = record.date {
            self.dateAndTimeLabel.text = date.shortFormattedDateString()
        }
        
        if let minTemperature = record.minTemperature, maxTemperature = record.maxTemperature {
            self.temperatureLabel.text = "\(String(format:"%.1f C", minTemperature))/\(String(format:"%.1f C", maxTemperature))"
        }
        
        if let weatherId = record.weatherId {
            // TODO: Potentially refactor to use with cell view model or static global helper function
            self.iconImageView.image = WeatherViewModel.imageForWeatherId(weatherId: weatherId)
        }
    }
}
