//
//  JourneyLastTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 06.09.2024.
//

import UIKit

class JourneyLastTableViewCell: UITableViewCell {

    @IBOutlet weak var finalTrackLbl: UILabel!
    @IBOutlet weak var stopTrackLbl: UILabel!
    @IBOutlet weak var finalStopTimeLbl: UILabel!
    @IBOutlet weak var stopTimeLbl: UILabel!
    @IBOutlet weak var finalStopLbl: UILabel!
    @IBOutlet weak var stopNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateFinalData(leg: Leg, stop: [Stop]) {
        // check if the stop is nil.
        let time = HelperFunctions.getTime(from: stop.last?.arrival ?? "")
        
        finalTrackLbl.text = ""
        stopTrackLbl.text = ""
        finalStopLbl.text = leg.exit?.name
        finalStopTimeLbl.text = HelperFunctions.getTime(from: leg.exit?.arrival ?? "")
        
        if time == nil {
            stopTimeLbl.text = HelperFunctions.getTime(from: leg.departure ?? "")
            stopNameLbl.text = leg.name
        } else {
            stopNameLbl.text = stop.last?.name
            stopTimeLbl.text = HelperFunctions.getTime(from: stop.last?.arrival ?? "")
        }
    }
}
