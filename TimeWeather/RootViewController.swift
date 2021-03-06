//
//  RootViewController.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/5/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import UIKit

enum SlideOutState {
    case Closed
    case Opened
}

class RootViewController: UIViewController {
    
    //MARK: - Properties
    
    fileprivate lazy var weatherVC: WeatherVC = {
        return UIStoryboard.weatherVC!
    }()
    
    var searchButton = UIBarButtonItem()
    
    let centerPanelExpandedOffset: CGFloat = 60
    var currentState: SlideOutState = .Closed {
        didSet {
            let shouldShowShadow = currentState != .Closed
            showShadowForCenterViewController(shouldShowShadow: shouldShowShadow)
        }
    }
    
    fileprivate lazy var locationSearchVC: LocationSearchVC = {
        let vc = UIStoryboard.locationSearchVC!
        vc.delegate = self
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherVC.delegate = self
        
        self.addChild(self.weatherVC)
        self.weatherVC.view.frame = self.view.bounds
        self.view.addSubview(self.weatherVC.view)
        self.weatherVC.didMove(toParent: self)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(type(of: self).didSelectSearch))
        
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Current Location", style: .plain, target: self, action: #selector(type(of: self).didSelectCurrentLocation))
    }
    
    @objc
    private func didSelectSearch() {
        self.weatherVC.delegate?.toggleRightPanel()
        self.locationSearchVC.locations.removeAll()
        self.searchButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.searchButton.isEnabled = true
        })
    }
    
    @objc
    private func didSelectCurrentLocation() {
        self.weatherVC.location = nil
    }
}


extension RootViewController: LocationSearchVCDelegate {
    
    func locationSearchVC(vc: LocationSearchVC, didSelectLocation location: Location) {
        self.weatherVC.location = location
        self.weatherVC.delegate?.toggleRightPanel()
    }

}

// MARK: - WeatherVC delegate

extension RootViewController: WeatherVCDelegate {
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .Opened)
        
        if notAlreadyExpanded {
            addChildSidePanelController(vc: self.locationSearchVC)
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addChildSidePanelController(vc: UIViewController) {
        let locationSearchVCViewYOrigin = self.navigationController!.navigationBar.frame.maxY
        let locationSearchVCViewWidth = self.weatherVC.view.frame.size.width - self.centerPanelExpandedOffset
        let locationSearchVCViewHeight = self.weatherVC.view.frame.size.height
        
        addChild(vc)
        vc.view.frame = CGRect(x: self.centerPanelExpandedOffset, y: locationSearchVCViewYOrigin , width: locationSearchVCViewWidth, height: locationSearchVCViewHeight)
        self.view.insertSubview(vc.view, at: 0)
        vc.didMove(toParent: self)
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        
        if (shouldExpand) {
            currentState = .Opened
            
            self.locationSearchVC.searchController.isActive = true
            
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            
            self.weatherVC.view.isUserInteractionEnabled = false
            
            animateCenterPanelXPosition(targetPosition: -self.weatherVC.view.frame.width + centerPanelExpandedOffset)
        } else {
            
            self.locationSearchVC.searchController.isActive = false
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            
            self.weatherVC.view.isUserInteractionEnabled = true
            
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .Closed
                
                self.locationSearchVC.view.removeFromSuperview()
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut , animations: {
            self.weatherVC.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            self.weatherVC.view.layer.shadowOpacity = 0.8
        } else {
            self.weatherVC.view.layer.shadowOpacity = 0.0
        }
    }
    
}

private extension UIStoryboard {
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static var weatherVC: WeatherVC? {
        return self.mainStoryboard().instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC
    }
    static var locationSearchVC: LocationSearchVC? {
        return self.mainStoryboard().instantiateViewController(withIdentifier: "LocationSearchVC") as? LocationSearchVC
    }
}
