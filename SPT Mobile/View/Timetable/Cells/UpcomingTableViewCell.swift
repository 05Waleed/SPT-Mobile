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
    
    func updateData(from: APIResponseDataModel, indexPath: IndexPath) {
        directionLbl.text = from.leg?[indexPath.row].exit?.name
        timeLbl.text = HelperFunctions.getTime(from: "\(from.leg?[indexPath.row].departure ?? "")")
        lineLbl.text = "\(from.leg?[indexPath.row].g ?? "") \(from.leg?[indexPath.row].l ?? "")"
    }
    
    func updateImage(from: APIResponseDataModel, indexPath: IndexPath) {
        if from.leg?[indexPath.row].type == "bus" {
            vehicleImg.image = UIImage(named: "bus 1")
        } else if from.leg?[indexPath.row].type == "strain" {
            vehicleImg.image = UIImage(named: "strain")
        } else if from.leg?[indexPath.row].type == "tram" {
            vehicleImg.image = UIImage(named: "tram")
        } else {
            vehicleImg.image = UIImage(named: "dot")
        }
    }
}
