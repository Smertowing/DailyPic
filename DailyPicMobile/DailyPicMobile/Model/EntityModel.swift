//
//  EntityModel.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 3/24/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

struct EntityModel: Codable {
    var id: String?
    var picture: String
    var date: Date
    var edited: Bool
    
    init?(id: String?, picture: String, date: Date) {
        self.id = id
        self.picture = picture
        self.date = date
        self.edited = false
    }
}

extension EntityModel: Equatable {
    public static func == (lhs: EntityModel, rhs: EntityModel) -> Bool {
        return lhs.date == rhs.date
    }
}

extension EntityModel {
    var backgroundColor: UIColor {
        return UIColor(hexString: String(Int.random(in: 0..<1000000)))
    }
}
