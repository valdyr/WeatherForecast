//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 21/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UICollectionViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var weatherForecastCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    // TODO: - Refactor currentWeatherView into a separate reusable View object, which may or may not have its view model, or extend WeatherViewModel for the view data, specifically formatted for Current Weather View
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var weatherViewModel: WeatherViewModel?
    
    // MARK: - Constants
    let weatherForecastCellReuseIdentifier = "WeatherForecastCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        self.setupSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.weatherViewModel?.updateModel({[unowned self] (error) -> (Void) in
        // TODO: - Improve error handling, user should be notified if anything goes wrong
            if error == nil &&
                self.weatherViewModel?.isDataAvailable == true {
                self.updateSubviews()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Model
    func setupViewModel() {
        self.weatherViewModel = WeatherViewModel(weatherServiceProvider: OpenWeatherMapWeatherService(), cellConfiguration: {[unowned self] (collectionView: UICollectionView, indexPath: NSIndexPath, record: WeatherRecord) -> (WeatherCell) in
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.weatherForecastCellReuseIdentifier, forIndexPath: indexPath) as! WeatherCell
            cell.configureCell(indexPath, record: record)
            
            return cell
        })
    }
    
    // MARK: - UI Updates
    func updateSubviews() {
        // TODO: - Refactor Current Weather View, scroll to the file top for details
        if let record = self.weatherViewModel?.weatherRecords[0] {
            self.setupCurrentWeatherView(with: record)
        }
        self.weatherForecastCollectionView.hidden = false
        self.weatherForecastCollectionView.reloadData()
    }

    // MARK: - UI Setup
    func setupSubviews() {
        self.prepareBackground()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.weatherForecastCollectionView.registerNib(UINib.init(nibName: WeatherCell.nibName(), bundle: nil), forCellWithReuseIdentifier: self.weatherForecastCellReuseIdentifier)
        self.weatherForecastCollectionView.dataSource = self.weatherViewModel
        self.weatherForecastCollectionView.delegate = self;
    }
    
    func prepareBackground() {
        self.backgroundImageView.image = UIImage(imageLiteral: "london-day")

        let blur = UIBlurEffect(style: .Dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.view.frame
        
        self.backgroundImageView.addSubview(effectView)
    }

    // TODO: - Refactor Current Weather View, scroll to the file top for details
    func setupCurrentWeatherView(with record: WeatherRecord) {
        self.activityIndicator.stopAnimating()
        self.locationLabel.text = record.locationName
        
        if let temperature = record.temperature {
            self.currentTemperatureLabel.text = String(format:"%.1f C", temperature)
        }
        
        if let minTemperature = record.minTemperature, maxTemperature = record.maxTemperature {
            self.minMaxTemperatureLabel.text = "\(String(format:"%.1f C", minTemperature))   |   \(String(format:"%.1f C", maxTemperature))"
        }
        
        self.weatherDescriptionLabel.text = record.describedAs?.capitalizedString
        
        if let weatherId = record.weatherId {
            self.weatherIconImageView.image = WeatherViewModel.imageForWeatherId(weatherId: weatherId)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    // TODO: - Implement tap on weather cell behaviour

}

