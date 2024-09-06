//
//  JourneyMiddleTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 06.09.2024.
//

import UIKit

class JourneyMiddleTableViewCell: UITableViewCell {

    @IBOutlet weak var trackLbl: UILabel!
    @IBOutlet weak var stopLblLeading: NSLayoutConstraint!
    @IBOutlet weak var stopLbl: UILabel!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var arrivalTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateData(stop: [Stop], at indexPath: IndexPath) {
        stopLbl.text = stop[indexPath.row - 1].name
        arrivalTimeLbl.text = HelperFunctions.getTime(from: stop[indexPath.row - 1].arrival)
        departureTimeLbl.text = HelperFunctions.getTime(from: stop[indexPath.row - 1].departure)
        trackLbl.text = ""
        stopLblLeading.constant = -20
    }
    
}
