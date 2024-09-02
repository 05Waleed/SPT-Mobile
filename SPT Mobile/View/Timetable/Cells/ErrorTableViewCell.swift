//
//  ErrorTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var openSettingsBttn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSettingBttn()
    }
    
    @IBAction func openSettingsBttnTap(_ sender: Any) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func setSettingBttn() {
        openSettingsBttn.layer.borderWidth = 1
        openSettingsBttn.layer.borderColor = UIColor(named: "ButtonBorder")?.cgColor
        openSettingsBttn.layer.cornerRadius = 25
    }
}

extension ErrorTableViewCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setSettingBttn()
        }
    }
}
