//
//  SegmentViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 09.09.2024.
//

import UIKit

class SegmentViewController: UIViewController {

    @IBOutlet weak var containerC: UIView!
    @IBOutlet weak var containerB: UIView!
    @IBOutlet weak var containerA: UIView!
    @IBOutlet weak var segmentView: SegmentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up initial state
        setupInitialView()
        
        // Handle segment changes
        segmentView.didTapSegment = { [weak self] index in
            DispatchQueue.main.async {
                self?.segmentControll()
            }
        }
    }
    
    private func setupInitialView() {
        // Ensure that only containerA is visible initially
        containerA.isHidden = false
        containerB.isHidden = true
        containerC.isHidden = true
    }
    
    private func segmentControll() {
        // Hide all containers
        containerA.isHidden = true
        containerB.isHidden = true
        containerC.isHidden = true
        
        // Show the selected container
        switch segmentView.currentIndex {
        case 0:
            containerA.isHidden = false
        case 1:
            containerB.isHidden = false
        case 2:
            containerC.isHidden = false
        default:
            break
        }
    }
}
