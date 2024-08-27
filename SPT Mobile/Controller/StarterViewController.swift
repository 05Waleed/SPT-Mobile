//
//  StarterViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 25.08.2024.
//

import UIKit

class StarterViewController: UIViewController {
    
    private let launchManager = LaunchManager(launchKey: "StarterViewControllerShown")
    
    @IBOutlet var starterView: StarterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfShown()
        setProperties()
    }
    
    private func setProperties() {
        starterView.starterViewController = self
    }
    
    private func checkIfShown() {
        if launchManager.isFirstLaunch() {
            navigateToTabbar()
        } else {
            starterView.showAnimation()
        }
    }
    
     func navigateToStarterInfoVc() {
        launchManager.setFirstLaunchFlag()
        print("navigate to starter info vc")
    }
    
   private func navigateToTabbar() {
        print("navigate to tab bar")
   }
}
