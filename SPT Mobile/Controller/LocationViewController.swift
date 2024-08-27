//
//  LocationViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 27.08.2024.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet var enableLocationView: LocationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setProperties()
        enableLocationView.startLottieAnimation() 
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func setProperties() {
        enableLocationView.locationViewController = self
    }
    
     func navigateToTabbar() {
        
    }
    
     
}
