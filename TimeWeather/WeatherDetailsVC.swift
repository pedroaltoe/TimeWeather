//
//  WeatherDetailsVC.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/3/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

class WeatherDetailsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - Properties
    
    private lazy var infoDays: InfoDayVC = {
        return self.childViewControllers.filter({ $0 is InfoDayVC }).first as! InfoDayVC
    }()
    private lazy var detailsDayVC: DetailsDayVC = {
        return self.childViewControllers.filter({ $0 is DetailsDayVC }).first as! DetailsDayVC
    }()
}
