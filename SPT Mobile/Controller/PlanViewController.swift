//
//  PlanViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

class PlanViewController: UIViewController {
    
    var locationModel: LocationModel?
    var planViewData: PlanViewData?
    var selectedDate: Date?
    var selectedTime: Date?
    
    @IBOutlet weak var timetableView: TimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformProtocols()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Calling the API here because it updates the data and location each time the user comes to this view controller
        
    }
    
    private func conformProtocols() {
        timetableView.connectionTableView.dataSource = self
        timetableView.connectionTableView.delegate = self
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
    
    private func registerXib() {
        timetableView.connectionTableView.register(UINib(nibName: "SearchLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchLocationTableViewCell")
        
        timetableView.connectionTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        
        timetableView.connectionTableView.register(UINib(nibName: "UpcomingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpcomingTableViewCell")
        
        timetableView.connectionTableView.register(UINib(nibName: "ErrorTableViewCell", bundle: nil), forCellReuseIdentifier: "ErrorTableViewCell")
        
        timetableView.connectionTableView.register(UINib(nibName: "LoaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LoaderTableViewCell")
    }
    
    private func fieldsAreActive() -> Bool {
        if timetableView.fromField.isFirstResponder || timetableView.toField.isFirstResponder {
            return true
        } else {
            return false
        }
    }
    
    private func updateTableViewHeightWithResponse() {
        timetableView.tableViewHeight.constant = timetableView.connectionTableView.contentSize.height
        updateContentViewHeight()
    }
    
    private func updateContentViewHeight() {
        let tableViewHeight = timetableView.connectionTableView.contentSize.height
        timetableView.contentViewHeight.constant = tableViewHeight + 500
        
    }
    
    private func updateTableViewHeightWithError() {
        timetableView.tableViewHeight.constant = 240
    }
    
    private func updateTableViewHeightWhileLoading() {
        timetableView.tableViewHeight.constant = 240
    }
    
    private func handleServiceResponse(_ response: ModelForCurrentLocation) {
        let allConnections = response.connections
        let allLegs = allConnections.flatMap { $0.legs }
        let allStops = allLegs.compactMap { $0.stops }.flatMap { $0 }
        planViewData = PlanViewData(connection: allConnections, legs: allLegs, stop: allStops)
        timetableView.connectionTableView.reloadData()
    }

    private func handleServiceError() {
        print("Eror in response")
    }
    
}

// MARK: UITextFieldDelegate
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

// MARK: Update Location
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

// MARK: Service Call
extension PlanViewController {
    private func serviceCallFromCurrentLocation() {
        guard let url =  NetworkManager.shared.setupURL(from: "\(locationModel?.cityName ?? "") \(locationModel?.streetName ?? "")", to: locationModel?.cityName ?? "", selectedDate: selectedDate, selectedTime: selectedTime) else {return}
        
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

// MARK: UITableViewDataSource, UITableViewDelegate
extension PlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use searchResults if not empty, else use planViewData
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if planViewData == nil {
            return loaderCell(tableView)
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if planViewData == nil {
            return heightForLoader(tableView, heightForRowAt: indexPath)
        } else {
            return 50
        }
    }
    
    private func searchLocationsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchLocationsCell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationTableViewCell") as! SearchLocationTableViewCell
        return searchLocationsCell
    }
    
    private func headerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
        
        if let planViewData = planViewData {
            headerCell.updateResponse(from: planViewData)
        } else {
            headerCell.updateError()
        }
        
        return headerCell
    }
    
    private func upcomingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let upcomingCell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell") as! UpcomingTableViewCell
        return upcomingCell
    }
    
    private func errorCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let errorCell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell") as! ErrorTableViewCell
        return errorCell
    }
    
    private func loaderCell(_ tableView: UITableView) -> UITableViewCell {
        let loaderCell = tableView.dequeueReusableCell(withIdentifier: "LoaderTableViewCell") as! LoaderTableViewCell
        
        if planViewData == nil {
            loaderCell.showLoader()
        } else {
            loaderCell.hideLoader()
        }
        
        return loaderCell
    }
    
    private func showLoader(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return headerCell(tableView, cellForRowAt: indexPath)
        case 1:
            return loaderCell(tableView)
        default:
            return UITableViewCell()
        }
    }
    
    private func heightForLoader(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        updateTableViewHeightWhileLoading()
        switch indexPath.row {
        case 0:
            return 87
        default:
            return 150
        }
    }
}
