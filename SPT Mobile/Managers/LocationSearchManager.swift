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
        
        let switzerlandCenter = CLLocationCoordinate2D(latitude: 46.8182, longitude: 8.2275)
        let regionSpan = MKCoordinateSpan(latitudeDelta: 3.0, longitudeDelta: 5.0)
        searchRequest.region = MKCoordinateRegion(center: switzerlandCenter, span: regionSpan)
        
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
            
            let results = response.mapItems.filter { mapItem in
                let placemark = mapItem.placemark
                return placemark.country?.lowercased() == "switzerland"
            }
            
            self?.delegate?.didReceiveSearchResults(results)
        }
    }
}
