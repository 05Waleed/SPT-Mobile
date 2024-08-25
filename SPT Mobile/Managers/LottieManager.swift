//
//  LottieManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 26.08.2024.
//

import UIKit
import Lottie

class LottieManager {
    static let shared = LottieManager()
    
    private var animationView: LottieAnimationView?
    
    private init() {}
    
    func startAnimation(on view: UIView, animationName: String, animationSpeed: CGFloat, loopMode: LottieLoopMode, completion: @escaping () -> Void) {
        // Stop and remove any existing animation view
        animationView?.stop()
        animationView?.removeFromSuperview()
        
        // Initialize and configure the LottieAnimationView
        let animationView = LottieAnimationView(name: animationName)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = animationSpeed
        animationView.loopMode = loopMode
        view.addSubview(animationView)
        
        // Play the animation and call the completion handler when finished
        animationView.play { (finished) in
            if finished {
                completion()
            }
        }
        
        // Store the animation view for possible future use
        self.animationView = animationView
    }
    
    func stopAnimation() {
        animationView?.stop()
        animationView?.removeFromSuperview()
        animationView = nil
    }
}
