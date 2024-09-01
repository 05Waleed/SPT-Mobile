//
//  HeaderTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var directionLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateResponse(from: PlanViewData) {
        currentLocationLbl.text = from.legs?.first?.terminal
        fromLbl.text = "From"
        directionLbl.text = "Direction"
    }
    
    func updateError() {
        currentLocationLbl.text = "Location unknown"
        fromLbl.text = ""
        directionLbl.text = ""
    }
    
    func updateWhileLoading() {
        currentLocationLbl.text = "Determining location..."
        fromLbl.text = ""
        directionLbl.text = ""
    }
}
