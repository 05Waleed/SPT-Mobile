//
//  CommonSearchLocationTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 27.10.2024.
//

import UIKit
import MapKit

class CommonSearchLocationTableViewCell {
    static let shared = CommonSearchLocationTableViewCell()
}

// MARK: - Methods for Showing Search Locations
extension CommonSearchLocationTableViewCell {
    func cellForRowWithSearchLocation(in tableView: UITableView, at indexPath: IndexPath, results: [MKMapItem], manager coreDataManager: CoreDataManager, from recentLocations: RecentLocations) -> UITableViewCell {
        
        if results.isEmpty {
            switch indexPath.row {
            case 0:
                return currentLocationCell(in: tableView, at: indexPath)
            default:
                return savedLocationCell(in: tableView, manager: coreDataManager, from: recentLocations, at: indexPath)
            }
        } else {
            return searchLocationCellConfiguration(in: tableView, at: indexPath, results: results)
        }
    }
    
    /// Private Methods for Search Locations State: Cell Configuration
    private func currentLocationCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentLocationTableViewCell") as! CurrentLocationTableViewCell
        return cell
    }
    
    private func searchLocationCellConfiguration(in tableView: UITableView, at indexPath: IndexPath, results: [MKMapItem]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationTableViewCell", for: indexPath) as! SearchLocationTableViewCell
       tableView.separatorStyle = .singleLine
        cell.updateSearchedResults(results: results, indexPath: indexPath)
        return cell
    }
    
    /// Methods for Saved Locations: Cell Configuration
    private func savedLocationCell(in tableView: UITableView, manager coreDataManager: CoreDataManager, from resultsObject: RecentLocations, at indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedSearchResultsTableViewCell", for: indexPath) as! SavedSearchResultsTableViewCell
        
        if let locations = coreDataManager.getStringArray(from: resultsObject) {
            cell.updateData(locations: locations, indexPath: indexPath)
        }
        
       return cell
    }
    
    /// Private Methods for Search Locations State: Cell Height
    func searchLocationCellHeight(indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70.0
        default:
            return 50.0
        }
    }
}
