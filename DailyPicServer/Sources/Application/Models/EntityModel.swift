//
//  EntityModel.swift
//  DailyPicServer
//
//  Created by Kiryl Holubeu on 3/24/19.
//

import Foundation

struct EntityModel: Codable {
    var id: String?
    var picture: String
    var date: Date
    
    init?(id: String?, picture: String, date: Date) {
        self.id = id
        self.picture = picture
        self.date = date
    }
}

extension EntityModel: Equatable {
    public static func == (lhs: EntityModel, rhs: EntityModel) -> Bool {
        return lhs.date == rhs.date
    }
}

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
