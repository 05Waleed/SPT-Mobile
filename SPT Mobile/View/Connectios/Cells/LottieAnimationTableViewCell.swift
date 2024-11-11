//
//  IdenticalStopsTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 08.11.2024.
//

import UIKit

class LottieAnimationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animationViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var animationViewLeading: NSLayoutConstraint!
    @IBOutlet weak var animationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var animationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLbl.isHidden = true
    }
    
    private func errorAnimation() {
        LottieManager.shared.startAnimation(on: animationView, animationName: "PsneFoGxsE", animationSpeed: 1.0, loopMode: .loop) {
        }
    }
    
    private func loaderAnimation() {
        LottieManager.shared.startAnimation(on: animationView, animationName: "LoaderIndicator", animationSpeed: 2.0, loopMode: .loop) {
        }
    }
    
    private func setupViews() {
        print("SetupViews called")
        descriptionLbl.isHidden = false
        animationViewHeight.constant = 210.0
        animationViewLeading.constant = 0
        animationViewTrailing.constant = 0
        self.layoutIfNeeded()
    }


    
    func showAnimation(isFetching: Bool) {
        if isFetching {
            loaderAnimation()
        } else {
            setupViews()
            errorAnimation()
        }
    }
}
