//
//  NextDaysVC.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 23/2/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

final class NextDaysVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        self.reloadData()
    }
    
    
    // MARK: - Private stuff
    
    private func reloadData() {
        guard self.isViewLoaded else { return }
        self.tableView.reloadData()
    }
    
    
    // MARK: - Public stuff

    
    weak var delegate: NextDaysVCDelegate?
    
    var forecasts: [Forecast] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    var currentWeather: [CurrentWeather] = [] {
        didSet {
            self.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource

extension NextDaysVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath)
    }
}


// MARK: - UITableViewDelegate

extension NextDaysVC {

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? WeatherCell else {
            preconditionFailure()
        }
        cell.configureCell(forecast: self.forecasts[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       self.delegate?.didSelectForecast(forecast: self.forecasts[indexPath.row])
    }
}

protocol NextDaysVCDelegate: NSObjectProtocol {
    
    func didSelectForecast(forecast: Forecast)
}
















