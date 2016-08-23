//
//  Extensions.swift
//  WeatherForecast
//
//  Created by Valeriy Dyryavyy on 22/08/2016.
//  Copyright © 2016 Valeriy Dyryavyy. All rights reserved.
//

import UIKit

// TODO: - Danger! Watch out for extensions file to grow exponentially and becoming a dump. Proper consideration and grouping by responsibility required.  

extension UIView {
    static func nibName() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

extension NSDate {
    func defaultFormattedDateString() -> String {
        return NSDateFormatter.DefaultDateFormatter.stringFromDate(self)
    }
    
    func shortFormattedDateString() -> String {
        return NSDateFormatter.ShortDateFormatter.stringFromDate(self)
    }
}

extension String {
    func defautFormattedDate() -> NSDate? {
        return NSDateFormatter.DefaultDateFormatter.dateFromString(self)
    }
}

extension NSDateFormatter {
    private static let DefaultDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static let ShortDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, H:mm a"
        return formatter
    }()
    
}
