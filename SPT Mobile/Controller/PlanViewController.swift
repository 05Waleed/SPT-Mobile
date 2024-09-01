//
//  PlanViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

class PlanViewController: UIViewController {
    
    var locationModel: LocationModel?
    var selectedDate: Date?
    
    @IBOutlet weak var timetableView: TimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformProtocols()
        performServiceCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Calling the API here because it updates the data and location each time the user comes to this view controller
        performServiceCall()
    }
    
    private func conformProtocols() {
        timetableView.fromField.delegate = self
        timetableView.toField.delegate = self
    }
    
    func performServiceCall() {
        updateLocation { success in
            if success {
                self.serviceCallFromCurrentLocation()
                print(self.locationModel as Any)
            } else {
                print("Unable to make service call from current location beacuse location not recieved")
            }
        }
    }
    
    private func handleServiceResponse(_ response: ModelForCurrentLocation) {
        print("data received")
    }
    
    private func handleServiceError() {
        print("Eror in response")
    }
}

extension PlanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timetableView.fromField {
            timetableView.setFieldsRemover()
            timetableView.setFromFieldText()
        } else if textField == timetableView.toField {
            timetableView.setFieldsRemover()
            timetableView.setFromFieldText()
        }
    }
}

extension PlanViewController {
    func updateLocation(completion: @escaping (Bool) -> Void) {
        LocationManager.shared.requestLocation { location, streetName, cityName, error in
            if let error = error {
                print("Failed to get location: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if location != nil {
                self.locationModel = LocationModel(streetName: streetName,
                                                   cityName: cityName)
                print(self.locationModel as Any)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

extension PlanViewController {
    private func serviceCallFromCurrentLocation() {
        guard let url = NetworkManager.shared.setupURL(from: "\(locationModel?.cityName ?? "") \(locationModel?.streetName ?? "")" ,to: locationModel?.cityName ?? "", selectedDate: selectedDate) else {
            return
        }
        
        NetworkManager.shared.performRequest(with: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataModel):
                    self?.handleServiceResponse(dataModel)
                case .failure(let error):
                    print("An error occurred while performing service call ERROR: \(error)")
                    self?.handleServiceError()
                }
            }
        }
    }
}
