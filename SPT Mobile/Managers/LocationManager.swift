//
//  LocationManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 27.08.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    private var locationCompletion: ((CLLocation?, String?, String?, Error?) -> Void)?
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation(completion: @escaping (CLLocation?, String?, String?, Error?) -> Void) {
        self.locationCompletion = completion
        let permissionRequested = UserDefaults.standard.bool(forKey: "locationPermissionRequested")
        
        if !permissionRequested {
            manager.requestWhenInUseAuthorization()
            UserDefaults.standard.set(true, forKey: "locationPermissionRequested")
        } else {
            manager.startUpdatingLocation()
        }
    }
    
    private func resolveLocationName(with location: CLLocation, completion: @escaping (String?, String?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil, nil)
                return
            }
            
            let cityName = place.locality
            let streetName = place.name
            completion(streetName, cityName)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            locationCompletion?(nil, nil, nil, NSError(domain: "LocationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied"]))
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .notDetermined:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()
        
        resolveLocationName(with: location) { [weak self] streetName, cityName in
            self?.locationCompletion?(location, streetName, cityName, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(nil, nil, nil, error)
    }
}
