//
//  StarterInfoViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 27.08.2024.
//

import UIKit

class StarterInfoViewController: UIViewController {

    @IBOutlet var starterInfoView: StarterInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setProperties()
    }
    
    private func setProperties() {
        starterInfoView.starterInfoViewController = self
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    func navigateToLocationVc() {
        
    }
}
