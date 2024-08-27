//
//  BaseTabBarViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 28.08.2024.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    private var circularViews = [UIView]() // Store circular views for each tab item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadow()
        addCircularBackgrounds()
        selectedIndex = 0
        // Set the initial selection background
        updateSelectedBackground(for: selectedIndex)
    }
    
    private func addShadow() {
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        tabBar.layer.shadowOpacity = 0.4
        tabBar.clipsToBounds = false
    }
    
    private func addCircularBackgrounds() {
        guard let items = tabBar.items else { return }
        
        let itemCount = CGFloat(items.count)
        let itemWidth = tabBar.frame.width / itemCount
        
        for (index, _) in items.enumerated() {
            let circularView = UIView()
            circularView.backgroundColor = UIColor.clear // Default to clear color
            circularView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            circularView.layer.cornerRadius = 20
            
            // Calculate the position
            let xPosition = (itemWidth * CGFloat(index)) + (itemWidth / 2) - 20
            let yPosition = tabBar.frame.height / 2 - 20
            
            circularView.frame.origin = CGPoint(x: xPosition, y: yPosition)
            
            tabBar.addSubview(circularView)
            tabBar.sendSubviewToBack(circularView)
            
            circularViews.append(circularView) // Store the circular view
        }
    }
    
    private func updateSelectedBackground(for index: Int) {
        for (i, circularView) in circularViews.enumerated() {
            if i == index {
                circularView.backgroundColor = UIColor.label
            } else {
                circularView.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            updateSelectedBackground(for: index)
        }
    }
}

