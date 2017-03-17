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
    
    
    // MARK: - Public stuff
    
    var weatherDetails: [WeatherDetails] = [] {
        didSet {
            self.reloadData()
        }
    }
}

    // MARK: - UITableViewDataSource
    
    extension DetailsDayVC {
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.weatherDetails.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier, for: indexPath)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    extension DetailsDayVC {
        
        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard let cell = cell as? DetailsCell else {
                preconditionFailure()
            }
            cell.configureDetailsDayCell(weatherDetails: weatherDetails[indexPath.row])
        }
    }

















