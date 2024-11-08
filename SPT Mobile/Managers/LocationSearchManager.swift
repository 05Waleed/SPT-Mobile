//
//  LocationSearchManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 08.09.2024.
//

import Foundation
import MapKit

protocol LocationSearchManagerDelegate: AnyObject {
    func didReceiveSearchResults(_ results: [MKMapItem])
    func didFailWithError(_ error: Error)
}

class LocationSearchManager {
    
    weak var delegate: LocationSearchManagerDelegate?
    
    func searchForLocation(query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        
        // Start the search without setting a specific region
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            if let error = error {
                self?.delegate?.didFailWithError(error)
                return
            }
            
            guard let response = response else {
                let error = NSError(domain: "LocationSearchManagerErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                self?.delegate?.didFailWithError(error)
                return
            }
            
            // Pass all results without filtering for a specific country
            self?.delegate?.didReceiveSearchResults(response.mapItems)
        }
    }
}
