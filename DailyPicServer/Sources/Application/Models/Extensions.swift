//
//  Extensions.swift
//  DailyPicServer
//
//  Created by Kiryl Holubeu on 3/24/19.
//

import Foundation
import SwiftyJSON

class Formatter {
    private static var internalJsonDateTimeFormatter: DateFormatter?
    
    static var jsonDateTimeFormatter: DateFormatter {
        if (internalJsonDateTimeFormatter == nil) {
            internalJsonDateTimeFormatter = DateFormatter()
            internalJsonDateTimeFormatter!.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        }
        return internalJsonDateTimeFormatter!
    }
}

// MARK: - String iso8601
extension String {
    public var iso8601: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: self)
    }
}

// MARK: - JSON dateTime
extension JSON {
    public var dateTime: Date? {
        switch type {
        case .string:
            return Formatter.jsonDateTimeFormatter.date(from: object as! String)
        default:
            return nil
        }
    }
}
