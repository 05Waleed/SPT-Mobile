//
//  StarterView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 25.08.2024.
//

import UIKit

class StarterView: UIView {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var trainAnimationView: UIView!
    
    weak var starterViewController: StarterViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadNib()
        setupMainView()
        setupTrainView()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("StarterView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupTrainView() {
        trainAnimationView.backgroundColor = .clear
        nameLbl.isHidden = true
    }
    
    private func animateNameLabel() {
        nameLbl.isHidden = false
        // Set the initial position of the label below its final position
        let originalPosition = nameLbl.frame.origin
        nameLbl.frame.origin.y = self.bounds.height
        
        // Set initial alpha to 0 (completely transparent)
        nameLbl.alpha = 0.0
        
        // Animate the label to its final position with a fade-in effect
        UIView.animate(withDuration: 1.5, delay: 2.5, options: [.curveEaseInOut]) {
            self.nameLbl.frame.origin = originalPosition
            self.nameLbl.alpha = 1.0  // Fade in
        }
    }
    
    func showAnimation() {
        animateNameLabel()
        LottieManager.shared.startAnimation(on: trainAnimationView, animationName: "fF9rPfdtXh", animationSpeed: 0.6, loopMode: .playOnce) {
            self.starterViewController?.navigateToStarterInfoVc()
        }
    }
}
