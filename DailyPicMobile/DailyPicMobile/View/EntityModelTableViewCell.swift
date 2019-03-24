//
//  EntityModelTableViewCell.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 3/24/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class EntityModelTableViewCell: UITableViewCell {
    @IBOutlet weak var entityImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func layoutSubviews() {
        dateLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        dateLabel.layer.shadowOpacity = 1
        dateLabel.layer.shadowRadius = 2
        timeLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        timeLabel.layer.shadowOpacity = 1
        timeLabel.layer.shadowRadius = 2
    }
    
    static var cellIdentifier = "EntityModelCell"
}
