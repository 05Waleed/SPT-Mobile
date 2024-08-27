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
         let vc = storyboard?.instantiateViewController(withIdentifier: "StarterInfoViewController") as! StarterInfoViewController
         navigationController?.pushViewController(vc, animated: true)
    }
    
   private func navigateToTabbar() {
       guard let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as? BaseTabBarViewController else {
           print("Unable to instantiate UITabBarController from storyboard.")
           return
       }
       
       tabBarVC.selectedIndex = 0
       
       if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first {
           window.rootViewController = tabBarVC
           window.makeKeyAndVisible()
       } else {
           print("Unable to find window scene or window.")
       }
   }
}
