//
//  LaunchManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 25.08.2024.
//

import Foundation

class LaunchManager {
    
    private let launchKey: String
    
    init(launchKey: String) {
        self.launchKey = launchKey
    }
    
    /// Checks if the view controller associated with this key has been shown before.
    func isFirstLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: launchKey)
    }
    
    /// Sets the flag indicating that the view controller has been shown.
    func setFirstLaunchFlag() {
        UserDefaults.standard.set(true, forKey: launchKey)
        UserDefaults.standard.synchronize() // Ensure the data is written to disk.
    }
}

