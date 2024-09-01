//
//  LoaderTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit

class LoaderTableViewCell: UITableViewCell {

    @IBOutlet weak var loaderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func showLoader() {
        contentView.isHidden = false
        LottieManager.shared.startAnimation(on: loaderView, animationName: "LoaderIndicator", animationSpeed: 2, loopMode: .loop) {
            print("")
        }
    }
    
    func hideLoader() {
        loaderView.isHidden = true
    }
}
