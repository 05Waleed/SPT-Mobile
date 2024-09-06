//
//  PlanViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

// MARK: PlanViewController
class PlanViewController: UIViewController {
    
    var locationModel: LocationModel?
    var planViewData: PlanViewData?
    var isFetching: Bool?
    
    @IBOutlet weak var timetableView: TimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformProtocols()
        registerXib()
        isFetching = true
        timetableView.fromFieldTextBasedOnFetching(planViewData: planViewData, isFetching: isFetching!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Calling the API here because it updates the data and location each time the user comes to this view controller
        performServiceCall()
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
                self.handleServiceError()
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
    
    private func updateTableViewHeightWithResponse() {
        DispatchQueue.main.async { [self] in
            timetableView.tableViewHeight.constant = timetableView.connectionTableView.contentSize.height
            updateContentViewHeight()
        }
    }
    
    private func updateContentViewHeight() {
        let tableViewHeight = timetableView.connectionTableView.contentSize.height
        timetableView.contentViewHeight.constant = tableViewHeight + 500
        
    }
    
    private func updateTableViewHeightWithError() {
        DispatchQueue.main.async { [self] in
            timetableView.tableViewHeight.constant = 280
        }
    }
    
    private func updateTableViewHeightWhileLoading() {
        DispatchQueue.main.async { [self] in
            timetableView.tableViewHeight.constant = 280
        }
    }
    
    private func handleServiceResponse(_ response: ModelForCurrentLocation) {
        let allConnections = response.connections
        let allLegs = allConnections.flatMap { $0.legs }
        let allStops = allLegs.compactMap { $0.stops }.flatMap { $0 }
        planViewData = PlanViewData(connection: allConnections, legs: allLegs, stop: allStops)
        timetableView.fromFieldTextBasedOnFetching(planViewData: planViewData, isFetching: isFetching!)
        timetableView.connectionTableView.reloadData()
    }
    
    private func handleServiceError() {
        print("Error in response")
        isFetching = false
        timetableView.fromFieldTextBasedOnFetching(planViewData: planViewData, isFetching: isFetching!)
        timetableView.connectionTableView.reloadData()
    }
    
    private func fieldsAreActive() -> Bool{
        timetableView.fromField.isFirstResponder || timetableView.toField.isFirstResponder ? true : false
    }
    
    private func navigateToJourneyInformationVc(indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "JourneyInformationViewController") as! JourneyInformationViewController
        vc.leg = planViewData?.legs?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UITextFieldDelegate
extension PlanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timetableView.fromField {
            timetableView.setFieldsRemover()
            timetableView.fromFieldTextBasedOnFocus(planViewData: planViewData)
            timetableView.fromField.returnKeyType = .next
        } else if textField == timetableView.toField {
            timetableView.fromFieldTextBasedOnFocus(planViewData: planViewData)
            timetableView.toField.returnKeyType = .search
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == timetableView.fromField {
            timetableView.toField.becomeFirstResponder()
        } else if textField == timetableView.toField {
            timetableView.fromField.becomeFirstResponder()
        }
        return false // Return false to prevent the default behavior of dismissing the keyboard
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
        guard let url =  NetworkManager.shared.setupURL(from: "\(locationModel?.cityName ?? "") \(locationModel?.streetName ?? "")", to: locationModel?.cityName ?? "") else {return}
        
        NetworkManager.shared.performRequest(with: url, isFetching: { isLoading in
            // Show or hide loading indicator
            if isLoading {
                self.isFetching = true
            } else {
                self.isFetching = false
            }
        }, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataModel):
                    self.handleServiceResponse(dataModel)
                case .failure(let error):
                    print("An error occurred while performing service call ERROR: \(error)")
                    self.handleServiceError()
                }
            }
        })
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFetching == true {
            return 2 // Show 2 rows during loading
        } else {
            return (planViewData?.legs?.count ?? 2) // Ensure at least 2 row for error or empty state
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFetching == true {
            return TableViewCellManager.shared.cellForRowWhileFetching(in: tableView, at: indexPath)
        } else if planViewData != nil {
            return TableViewCellManager.shared.cellForRowWhileUpdatingData(in: tableView, at: indexPath, planViewData: planViewData!)
        } else {
            return TableViewCellManager.shared.cellForRowWithError(in: tableView, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFetching == true {
            updateTableViewHeightWhileLoading()
            return TableViewCellManager.shared.heightForRowWhileFetching(in: tableView, at: indexPath)
        } else if let legs = planViewData?.legs, indexPath.row < legs.count {
            updateTableViewHeightWithResponse()
            return TableViewCellManager.shared.heightForRowWhileUpdatingData(in: tableView, at: indexPath, leg: planViewData?.legs?[indexPath.row])
        } else {
            updateTableViewHeightWithError()
            return TableViewCellManager.shared.errorCellHeight(in: tableView, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timetableView.connectionTableView.deselectRow(at: indexPath, animated: true)
        
        if !fieldsAreActive() {
            navigateToJourneyInformationVc(indexPath: indexPath)
        }
    }
}
