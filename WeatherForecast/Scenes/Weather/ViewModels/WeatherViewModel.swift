//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 22/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import UIKit

typealias WeatherCellConfiguration = (UICollectionView, NSIndexPath, WeatherRecord) -> (WeatherCell)
typealias WeatherViewModelCompletion = (WeatherServiceError?) -> (Void)

class WeatherViewModel: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    var weatherRecords: [WeatherRecord] = []
    var cellConfiguration: WeatherCellConfiguration
    let serviceProvider: WeatherServiceProvider
    var isDataAvailable: Bool {
        return self.weatherRecords.count > 0
    }
    
    init(weatherServiceProvider: WeatherServiceProvider, cellConfiguration: WeatherCellConfiguration) {
        self.serviceProvider = weatherServiceProvider
        self.cellConfiguration = cellConfiguration
    }
    
    // MARK: - Public API
    func updateModel(completion: WeatherViewModelCompletion) {
        self.serviceProvider.requestWeatherForecast(nil) {[unowned self] (receivedRecords, error) in
                        
            if error != nil {
                completion(error)
                
            } else if let records = receivedRecords {
                self.weatherRecords = records
                completion(nil)
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherRecords.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.cellConfiguration(collectionView, indexPath, self.weatherRecords[indexPath.item])
    }
}

// TODO: - Trade-off -> Find a better place for matching image to weatherId
extension WeatherViewModel {
    static func imageForWeatherId(weatherId id: Int) -> UIImage {
        let imageName: String
        
        switch id {
            
        case 300...321, 500...504:
            imageName = "rain"
            
        case 200...232, 511, 520...521, 531:
            imageName = "chancetstorms"
            
        case 600..<700:
            imageName = "sleet"
            
        case 700..<800:
            imageName = "fog"
            
        case 800:
            imageName = "clear"
            
        case 801...804:
            imageName = "cloudy"
            
        case 900...906:
            imageName = "tstorms"
            
        default:
            imageName = "mostlysunny"
        }
        
        return UIImage(imageLiteral: imageName);
    }
}
