//
//  DetailsDayVC.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class DetailsDayVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadData()
    }
    
    // MARK: - Private stuff
    
    private func reloadData() {
        guard self.isViewLoaded else { return }
        self.tableView.reloadData()
    }
    
    fileprivate let cellKinds: [DetailsCell.Kind] = [.pressure, .humidity, .windSpeed, .WindDirection]
    
    
    // MARK: - Public stuff
    
    var detailsDay = Forecast() {
        didSet {
            self.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension DetailsDayVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellKinds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier, for: indexPath)
    }
    
}


extension DetailsDayVC {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DetailsCell else {
            preconditionFailure()
        }
        let kind = self.cellKinds[indexPath.row]
        kind.configureCell(cell, forecast: self.detailsDay)
    }
    
}


private extension DetailsCell.Kind {
    
    func configureCell(_ cell: DetailsCell, forecast: Forecast) {
        let title: String
        let value: String
        let detailsIcon: UIImage
        
        switch self {
        case .pressure:
            title = NSLocalizedString("Pressure", comment: "")
            value = NSLocalizedString(forecast.pressure + " hPa", comment: "Pressure Value in Hectopascal")
            detailsIcon = UIImage(named: "pressureIcon")!
        case .humidity:
            title = NSLocalizedString("Humidity", comment: "")
            value = NSLocalizedString(forecast.humidity + " %", comment: "Humidity Percentage")
            detailsIcon = UIImage(named: "humidityIcon")!
        case .windSpeed:
            title = NSLocalizedString("Wind Speed", comment: "")
            value = NSLocalizedString(forecast.windSpeed + " KM/H", comment: "Wind Speed")
            detailsIcon = UIImage(named: "windSpeedIcon")!
        case .WindDirection:
            title = NSLocalizedString("Wind Direction", comment: "")
            value = Double(forecast.windDirection)?.direction ?? "--"
            detailsIcon = UIImage(named: "windDirectionIcon")!
        }
        
        cell.titleLabel.text = title
        cell.valueLabel.text = value
        cell.detailsIcon.image = detailsIcon
    }
    
}


private extension Double {
    
    var direction: String {
        switch self {
        case 0..<11.25, 348.75...360: return "N"
        case 11.25..<33.75: return "NNE"
        case 33.75..<56.25: return "NE"
        case 56.25..<78.75: return "ENE"
        case 78.75..<101.25: return "E"
        case 101.25..<123.75: return "ESE"
        case 123.75..<146.25: return "SE"
        case 146.25..<168.75: return "SSE"
        case 168.75..<191.25: return "S"
        case 191.25..<213.75: return "SSW"
        case 213.75..<236.25: return "SW"
        case 236.25..<258.75: return "WSW"
        case 258.75..<281.25: return "W"
        case 281.25..<303.75: return "WNW"
        case 303.75..<326.25: return "NW"
        case 326.25..<348.75: return "NNW"
        default: preconditionFailure()
        }
    }
    
}
