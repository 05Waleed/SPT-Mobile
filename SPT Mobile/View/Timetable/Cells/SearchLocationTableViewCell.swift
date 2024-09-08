//
//  SearchLocationTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit
import MapKit

class SearchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func updateSearchedResults(results: [MKMapItem], indexPath: IndexPath) {
        if results.isEmpty {
            locationNameLbl.text = results[indexPath.row - 1].name
        } else {
            locationNameLbl.text = results[indexPath.row].name
        }
    }
}
