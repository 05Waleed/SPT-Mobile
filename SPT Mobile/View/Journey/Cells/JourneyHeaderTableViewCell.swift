//
//  JourneyHeaderTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 06.09.2024.
//

import UIKit

class JourneyHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var stopLblLeading: NSLayoutConstraint!
    @IBOutlet weak var platformLbl: UILabel!
    @IBOutlet weak var stopLbl: UILabel!
    @IBOutlet weak var arrivalTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(leg: Leg) {
        let departure = HelperFunctions.getTime(from: leg.departure ?? "")
        let arrival = HelperFunctions.getTime(from: leg.arrival ?? "")
        platformLbl.text = ""
        stopLblLeading.constant = -20
        stopLbl.text = leg.name
        arrivalTimeLbl.text = arrival
        departureTimeLbl.text = departure
    }
}
