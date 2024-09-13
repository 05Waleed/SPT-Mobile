//
//  SavedSearchResultsTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 13.09.2024.
//

import UIKit

class SavedSearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var recentLocationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateData(locations: [String], indexPath: IndexPath) {
        recentLocationLbl.text = locations[indexPath.row - 1]
    }
}
