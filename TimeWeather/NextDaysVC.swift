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
        
        self.reloadData()
    }
    
    
    // MARK: - Private stuff
    
    private func reloadData() {
        guard self.isViewLoaded else { return }
        self.tableView.reloadData()
    }
    
    
    // MARK: - Public stuff
    
    var forecasts: [Forecast] = [] {
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
        cell.configureCell(forecast: forecasts[indexPath.row])
    }
}


