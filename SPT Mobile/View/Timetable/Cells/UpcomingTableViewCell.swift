//
//  UpcomingTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var directionLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var vehicleImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func updateData(from: PlanViewData, indexPath: IndexPath) {
       
    }
    
}
