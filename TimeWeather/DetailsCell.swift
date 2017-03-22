//
//  DetailsCell.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 16/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    enum Kind {
        case pressure, humidity, windSpeed, WindDirection
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    public static let identifier = "DetailsCell"
}
