//
//  LocationSearchCell.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 16/5/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class LocationSearchCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    func configureCell(location: Location) {
        
        self.placeNameLabel.text = NSLocalizedString(location.description, comment: "Location Description").uppercased()
    }

    public static let identifier = "LocationSearchCell"
}
