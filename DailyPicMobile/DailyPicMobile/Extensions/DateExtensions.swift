//
//  DateExtensions.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 3/24/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

extension Date {
    var iso8601: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
    
    var displayTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: self)
    }
}
