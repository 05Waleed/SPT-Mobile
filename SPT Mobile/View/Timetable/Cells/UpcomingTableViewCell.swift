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
        directionLbl.text = from.legs?[indexPath.row].exit?.name
        
        timeLbl.text = HelperFunctions.getTime(from: "\(from.legs?[indexPath.row].departure ?? "")")
        
        lineLbl.text = "\(from.legs?[indexPath.row].g ?? "") \(from.legs?[indexPath.row].l ?? "")"        
    }
    
    func updateImage(from: PlanViewData, indexPath: IndexPath) {
        if from.legs?[indexPath.row].type == "bus" {
            vehicleImg.image = UIImage(named: "bus 1")
        } else if from.legs?[indexPath.row].type == "strain" {
            vehicleImg.image = UIImage(named: "strain")
        } else if from.legs?[indexPath.row].type == "tram" {
            vehicleImg.image = UIImage(named: "tram")
        } else {
            vehicleImg.image = UIImage(named: "dot")
        }
    }
}
