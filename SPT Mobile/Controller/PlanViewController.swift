//
//  PlanViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit
import MapKit

// MARK: - PlanViewController
class PlanViewController: UIViewController {
    
    private let coreDataManager = CoreDataManager.shared
    private let locationSearchManager = LocationSearchManager()
    private var resultsObject: RecentLocations? // Object to store Core Data results
     var locationModel: LocationModel?
    private var responseModel: APIResponseDataModel?
    private var isFetching: Bool = true
    private var searchResults: [MKMapItem] = []
    
    @IBOutlet weak var timetableView: TimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDelegates()
        timetableView.updateView(isFetching: isFetching, responseModel: responseModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performServiceCall()
    }
    
    private func setupView() {
        registerXib()
    }
    
    private func configureDelegates() {
        timetableView.planViewController = self
        timetableView.connectionTableView.dataSource = self
        timetableView.connectionTableView.delegate = self
        timetableView.fromField.delegate = self
        timetableView.toField.delegate = self
        locationSearchManager.delegate = self
    }
    
    private func registerXib() {
        let nibNames = [
            "SearchLocationTableViewCell",
            "ConnectionHeaderTableViewCell",
            "UpcomingTableViewCell",
            "ErrorTableViewCell",
            "LoaderTableViewCell",
            "CurrentLocationTableViewCell",
            "SavedSearchResultsTableViewCell"
        ]
        
        nibNames.forEach {
            timetableView.connectionTableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }
    }
    
    private func performServiceCall() {
        updateLocation { [weak self] success in
            guard let self = self else { return }
            if success {
                self.serviceCallFromCurrentLocation()
            } else {
                self.handleServiceError()
            }
        }
    }
    
    private func updateTableViewHeight(plus: Double = 0.0) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.timetableView.tableViewHeight.constant = self.timetableView.connectionTableView.contentSize.height + plus
                self.view.layoutIfNeeded()
            }
            self.updateContentViewHeight()
        }
    }
    
    private func updateContentViewHeight() {
        timetableView.contentViewHeight.constant = timetableView.connectionTableView.contentSize.height + 500
    }
    
    private func handleServiceResponse(_ response: ModelForCurrentLocation) {
        let allConnections = response.connections
        let allLegs = allConnections.flatMap { $0.legs }
        let allStops = allLegs.flatMap { $0.stops }.flatMap { $0 }
        responseModel = APIResponseDataModel(connection: allConnections, leg: allLegs, stop: allStops)
        timetableView.updateView(isFetching: isFetching, responseModel: responseModel)
        timetableView.connectionTableView.reloadData()
    }
    
    private func handleServiceError() {
        isFetching = false
        timetableView.updateView(isFetching: isFetching, responseModel: responseModel)
        timetableView.connectionTableView.reloadData()
    }
    
    private func fieldsAreActive() -> Bool {
        timetableView.fromField.isFirstResponder || timetableView.toField.isFirstResponder
    }
    
    private func navigateToJourneyInformationVc(indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "JourneyInformationViewController") as? JourneyInformationViewController else { return }
        vc.leg = responseModel?.leg?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateFieldsWithLocation(result: [MKMapItem]?, saved location: [String]?, at indexPath: IndexPath) {
        // Determine the location to show
        let locationToShow: String?
        
        if let result = result, !result.isEmpty {
            // If result is non-empty, use its data
            locationToShow = result[indexPath.row].name
        } else if let saved = location, !saved.isEmpty {
            // Ensure that indexPath.row - 1 is within bounds
            let index = indexPath.row - 1
            if index >= 0 && index < saved.count {
                locationToShow = saved[index]
            } else {
                locationToShow = nil
            }
        } else {
            // If both result and saved are empty
            locationToShow = nil
        }
        
        // Update fields based on the current first responder
        if timetableView.fromField.isFirstResponder {
            timetableView.fromField.text = locationToShow
            if timetableView.toField.text?.isEmpty == true {
                timetableView.toField.becomeFirstResponder()
            }
        } else if timetableView.toField.isFirstResponder {
            timetableView.toField.text = locationToShow
            if timetableView.fromField.text?.isEmpty == true {
                timetableView.fromField.becomeFirstResponder()
            }
        }
    }
    
    
    func removeSearchResults() {
        searchResults.removeAll()
        timetableView.connectionTableView.reloadData()
    }
    
    private func saveSearchResults(location: MKMapItem) {
        // Get the existing recent locations, decode if needed
        var updatedLocations = coreDataManager.getStringArray(from: resultsObject!) ?? []
        
        // Extract relevant info from MKMapItem (e.g., its name)
        if let locationName = location.name {
            if !updatedLocations.contains(locationName) {
                updatedLocations.append(locationName) // Append the location's name as a String
            }
        }
        
        // Encode the updated array and save it to Core Data
        coreDataManager.saveStringArray(updatedLocations, to: resultsObject!)
    }
    
    private func fetchSearchResults() {
        // Fetch the Core Data object (if it exists)
        if let fetchedResults = coreDataManager.fetchResults() {
            resultsObject = fetchedResults
        } else {
            // If no existing object is found, create a new one
            resultsObject = RecentLocations(context: coreDataManager.context)
        }
        
        timetableView.connectionTableView.reloadData()
    }
    
    func navigateToConnectionsVc() {
        let vc = storyboard?.instantiateViewController(identifier: "ConnectionsViewController") as! ConnectionsViewController
        
        if let nearestStop = responseModel?.leg?.first?.terminal {
            let connectionsDataModel = ConnectionsDataModel(fromText: nearestStop, toText: timetableView.toField.text ?? "")
            vc.connectionsDataModel = connectionsDataModel
        }
        
        timetableView.dismissKeyboard()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension PlanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timetableView.fromField {
            timetableView.configureViewForSearchLocation()
            updateTableViewHeight(plus: 50)
            timetableView.updateFromFieldTextBasedOnFocus(planViewData: responseModel)
            timetableView.fromField.returnKeyType = .next
            fetchSearchResults()
        } else if textField == timetableView.toField {
            timetableView.configureViewForSearchLocation()
            timetableView.updateFromFieldTextBasedOnFocus(planViewData: responseModel)
            timetableView.toField.returnKeyType = .search
            fetchSearchResults()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == timetableView.fromField {
            timetableView.toField.becomeFirstResponder()
        } else if textField == timetableView.toField {
            if timetableView.fromField.text?.isEmpty == true {
                timetableView.fromField.becomeFirstResponder()
            } else if timetableView.fromField.text != "" && timetableView.toField.text != ""{
                navigateToConnectionsVc()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        if !updatedText.isEmpty {
            searchForLocation(query: updatedText)
        } else {
            searchResults.removeAll()
            timetableView.connectionTableView.reloadData()
        }
        
        return true
    }
}

// MARK: - LocationSearchManagerDelegate
extension PlanViewController: LocationSearchManagerDelegate {
    func searchForLocation(query: String) {
        locationSearchManager.searchForLocation(query: query)
    }
    
    func didReceiveSearchResults(_ results: [MKMapItem]) {
        searchResults = results
        timetableView.connectionTableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        print("Search error: \(error.localizedDescription)")
    }
}

// MARK: - Location Update
extension PlanViewController {
    private func updateLocation(completion: @escaping (Bool) -> Void) {
        LocationManager.shared.requestLocation { [weak self] location, streetName, cityName, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to get location: \(error.localizedDescription)")
                completion(false)
            } else if location != nil {
                self.locationModel = LocationModel(streetName: streetName, cityName: cityName)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

// MARK: - Service Call
extension PlanViewController {
    private func serviceCallFromCurrentLocation() {
        // Construct the URL using the current location data.
        guard let url = NetworkManager.shared.setupURL(from: "\(locationModel?.cityName ?? "") \(locationModel?.streetName ?? "")", to: locationModel?.cityName ?? "") else { return }
        
        // Call the generic performRequest method, specifying the expected data model.
        NetworkManager.shared.performRequest(with: url, isFetching: { [weak self] isLoading in
            // Update the fetching state (e.g., show or hide a loading indicator).
            self?.isFetching = isLoading
        }, completion: { [weak self] (result: Result<ModelForCurrentLocation, Error>) in
            // Handle the result on the main thread.
            DispatchQueue.main.async {
                switch result {
                case .success(let dataModel):
                    // Handle the success response with the data model.
                    self?.handleServiceResponse(dataModel)
                case .failure(let error):
                    // Log and handle the error appropriately.
                    print("Service call error: \(error)")
                    self?.handleServiceError()
                }
            }
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fieldsAreActive() {
            // When fields are active, determine the number of rows based on searchResults or Core Data
            if let resultsObject = resultsObject {
                return searchResults.isEmpty ? (coreDataManager.getStringArray(from: resultsObject)?.count ?? 0) + 1 : searchResults.count
            } else {
                return searchResults.count
            }
        } else {
            // When fields are not active, determine the number of rows based on fetching state and planViewData
            return isFetching ? 2 : (responseModel?.leg?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fieldsAreActive() {
            return CommonSearchLocationTableViewCell.shared.cellForRowWithSearchLocation(in: tableView, at: indexPath, results: searchResults, manager: coreDataManager, from: resultsObject ?? RecentLocations())
        } else {
            if isFetching {
                return cellForRowWhileFetching(in: tableView, at: indexPath)
            } else if let planViewData = responseModel {
                return cellForRowWhileUpdatingData(in: tableView, at: indexPath, planViewData: planViewData)
            } else {
                return cellForRowWithError(in: tableView, at: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timetableView.connectionTableView.deselectRow(at: indexPath, animated: true)
        
        if fieldsAreActive() {
            if !searchResults.isEmpty {
                updateFieldsWithLocation(result: searchResults, saved: [], at: indexPath)
                saveSearchResults(location: searchResults[indexPath.row])
                // post a notification when row is selected
                NotificationCenter.default.post(name: .touchCollectionViewDidUpdate, object: nil)
            } else if let locations = coreDataManager.getStringArray(from: resultsObject ?? RecentLocations()) {
                updateFieldsWithLocation(result: [], saved: locations, at: indexPath)
            }
        } else if indexPath.row > 0 && responseModel != nil {
            navigateToJourneyInformationVc(indexPath: indexPath)
        }
        
         if fieldsAreActive() && timetableView.fromField.text != "" && timetableView.toField.text != "" {
            navigateToConnectionsVc()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fieldsAreActive() {
            updateTableViewHeight(plus: 50.0)
            return CommonSearchLocationTableViewCell.shared.searchLocationCellHeight(indexPath: indexPath)
        } else {
            if isFetching {
                updateTableViewHeight()
                return heightForRowWhileFetching(in: tableView, at: indexPath)
            } else if let legs = responseModel?.leg, indexPath.row < legs.count {
                updateTableViewHeight()
                return heightForRowWhileUpdatingData(in: tableView, at: indexPath, leg: responseModel?.leg?[indexPath.row])
            } else {
                updateTableViewHeight()
                return errorCellHeight(in: tableView, at: indexPath)
            }
        }
    }
}
