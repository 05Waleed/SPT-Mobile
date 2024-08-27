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
    
    func updateLocation(completion: @escaping (Bool) -> Void) {
        LocationManager.shared.requestLocation { location, streetName, cityName, error in
            if let error = error {
                print("Failed to get location: \(error.localizedDescription)")
                return
            }
            
            if location != nil {
                completion(true)
            }
        }
    }
}
