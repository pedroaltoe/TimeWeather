//
//  TableViewController.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 16/5/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit


protocol LocationSearchVCDelegate: NSObjectProtocol {
    func locationSearchVC(vc: LocationSearchVC, didSelectLocation location: Location)
}

class LocationSearchVC: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    var searchController: UISearchController!
    
    weak var delegate: LocationSearchVCDelegate?
    
    var weatherVC: WeatherVC!
    
    var locations: [Location] = [] {
        didSet {
            self.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadData()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
    
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
    }
    
    func reloadData() {
        guard self.isViewLoaded else { return }
        self.tableView.reloadData()
    }
}


// MARK: - UITableViewDataSource

extension LocationSearchVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: LocationSearchCell.identifier, for: indexPath)
    }
}


// MARK: - UITableViewDelegate

extension LocationSearchVC {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? LocationSearchCell else {
            preconditionFailure()
        }
        cell.configureCell(location: locations[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.locationSearchVC(vc: self, didSelectLocation: self.locations[indexPath.row])
        self.searchController.isActive = !self.searchController.isActive
    }
}


//MARK: - UISearchBarDelegate

extension LocationSearchVC {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.folding(options: .diacriticInsensitive, locale: .current)
        LocationAPI.searchLocation(query: text.replacingOccurrences(of: " ", with: "")) { [weak self] locations in
            DispatchQueue.main.async {
                self?.locations = locations
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.locations.removeAll()
    }
}
