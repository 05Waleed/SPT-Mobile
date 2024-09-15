//
//  TouchCollectionViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 15.09.2024.
//

import UIKit

class RecentSearchedLocationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func updateLocation(recentLocations: [String], defaultLocations: DefaultLocations, at indexPath: IndexPath) {
        
        // Start with recent locations, ensuring uniqueness using a Set
        var mergedLocations = recentLocations
        
        // Convert to a Set for quick lookup to avoid duplicates
        let mergedLocationSet = Set(mergedLocations)
        
        // Filter default locations to add only those not already in mergedLocations
        let filteredDefaultLocations = defaultLocations.locations.filter { !mergedLocationSet.contains($0) }
        
        // Add only the required number of default locations to reach 10 items
        let neededDefaultsCount = max(0, 10 - mergedLocations.count)
        mergedLocations.append(contentsOf: filteredDefaultLocations.prefix(neededDefaultsCount))
        
        // Handle special labels for index 10, 11, 12
        switch indexPath.row {
        case 10:
            locationNameLbl.text = "Current location"
        case 11:
            locationNameLbl.text = "From"
        case 12:
            locationNameLbl.text = "To"
        default:
            // Ensure the index is within bounds and set the location name
            if indexPath.row < mergedLocations.count {
                locationNameLbl.text = mergedLocations[indexPath.row]
            }
        }
    }
}
