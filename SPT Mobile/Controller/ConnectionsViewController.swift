//
//  ConnectionsViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 16.09.2024.
//

import UIKit
import MapKit

class ConnectionsViewController: UIViewController {
    
    @IBOutlet var connectionsView: ConnectionsView!
    
    private var searchResults: [MKMapItem] = []
    private let locationSearchManager = LocationSearchManager()
    private var responseModel: APIResponseDataModelForSelectedLocation?
    private var isFetching: Bool = true
    var connectionsDataModel: ConnectionsDataModel?
    private let coreDataManager = CoreDataManager.shared
    private var resultsObject: RecentLocations? // Object to store Core Data results
    var selectedDateAndTime: SelectedDateAndTime?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformProtocols()
        registerXib()
        connectionsView.updateFields(connectionsDataModel: connectionsDataModel ?? ConnectionsDataModel(fromText: "", toText: ""))
        registerForKeyboardNotifications()
        tableViweVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        serviceCallForSearchPoints(from: connectionsView.fromField.text ?? "", to: connectionsView.toField.text ?? "", date: selectedDateAndTime?.apiDateString ?? "", time: selectedDateAndTime?.timeString ?? "")
    }
    
    deinit {
        // Unregister from notifications when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    private func conformProtocols() {
        connectionsView.fromField.delegate = self
        connectionsView.toField.delegate = self
        connectionsView.connectionsTableView.dataSource = self
        connectionsView.connectionsTableView.delegate = self
        connectionsView.scrollView.delegate = self
        locationSearchManager.delegate = self
        connectionsView.connectionsViewController = self
    }
    
    private func registerXib() {
        let nibNames = [
            "SearchLocationTableViewCell",
            "ConnectionsTableViewCell",
            "SavedSearchResultsTableViewCell",
            "CurrentLocationTableViewCell"
        ]
        
        nibNames.forEach {
            connectionsView.connectionsTableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }
    }
    
    // MARK: - Keyboard Notification Handling
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        connectionsView.hideSwapper() // Hide the swapper when the keyboard appears
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        connectionsView.showSwapper() // Show the swapper when the keyboard disappears
    }
    
    private func handleServiceResponse(_ response: ModelForSelectedLocation) {
        let allConnections = response.connections
        let allLegs = allConnections.flatMap { $0.legs }
        let allStops = allLegs.flatMap { $0.stops }.flatMap { $0 }
        responseModel = APIResponseDataModelForSelectedLocation(connection: allConnections, legs: allLegs, stop: allStops)
        tableViweVisibility()
        connectionsView.connectionsTableView.reloadData()
        connectionsView.dismissKeyboard()
    }
    
    private func handleServiceError(error: Error) {
        isFetching = false
        tableViweVisibility()
        print("Service call error: \(error)")
        connectionsView.connectionsTableView.reloadData()
        connectionsView.dismissKeyboard()
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
        
        connectionsView.connectionsTableView.reloadData()
    }
    
    private func removeSearchResults() {
        searchResults.removeAll()
        connectionsView.connectionsTableView.reloadData()
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
        if connectionsView.fromField.isFirstResponder {
            connectionsView.fromField.text = locationToShow
            if connectionsView.toField.text?.isEmpty == true {
                connectionsView.toField.becomeFirstResponder()
            }
        } else if connectionsView.toField.isFirstResponder {
            connectionsView.toField.text = locationToShow
            if connectionsView.fromField.text?.isEmpty == true {
                connectionsView.fromField.becomeFirstResponder()
            }
        }
    }
    
    func showTravelDateVc() {
        let vc = storyboard?.instantiateViewController(identifier: "TravelDateViewController") as! TravelDateViewController
        vc.modalPresentationStyle = .formSheet // or .formSheet, depending on your needs
        vc.modalTransitionStyle = .coverVertical // optional transition style
        vc.delegate = self
        // For iOS 15 and above, you can control the sheet size even further:
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()] // medium for half screen, large for full screen
            sheet.prefersGrabberVisible = false // adds a handle for dragging
        }

        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension ConnectionsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == connectionsView.fromField || textField == connectionsView.toField {
            connectionsView.showFieldBttns() // Show field buttons when editing begins
            fetchSearchResults()
            connectionsView.configureViewForSearchLocation()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == connectionsView.fromField || textField == connectionsView.toField {
            connectionsView.hideFieldBttns() // Hide field buttons when editing ends
            connectionsView.resetViewAppearance()
            removeSearchResults()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == connectionsView.fromField {
            connectionsView.toField.becomeFirstResponder()
        } else if textField == connectionsView.toField {
            if connectionsView.fromField.text?.isEmpty == true {
                connectionsView.fromField.becomeFirstResponder()
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
            connectionsView.connectionsTableView.reloadData()
        }
        
        return true
    }
}

// MARK: - Network Call
extension ConnectionsViewController {
    private func serviceCallForSearchPoints(from: String, to: String, date: String, time: String) {
        guard let url = NetworkManager.shared.setupURLForSearchPoints(from: from, to: to, formattedDate: date, time: time) else { return }
        
        // Call the generic performRequest method, specifying the expected data model.
        NetworkManager.shared.performRequestForSearchPoints(with: url, isFetching: { [weak self] isLoading in
            // Update the fetching state (e.g., show or hide a loading indicator).
            self?.isFetching = isLoading
        }, completion: { [weak self] (result: Result<ModelForSelectedLocation, Error>) in
            // Handle the result on the main thread.
            DispatchQueue.main.async {
                switch result {
                case .success(let dataModel):
                    // Pass the data model to a handler function in your view controller.
                    self?.handleServiceResponse(dataModel)
                case .failure(let error):
                    // Log the error and handle it appropriately.
                    self?.handleServiceError(error: error)
                }
            }
        })
    }
}

// MARK: - LocationSearchManagerDelegate
extension ConnectionsViewController: LocationSearchManagerDelegate {
    func searchForLocation(query: String) {
        locationSearchManager.searchForLocation(query: query)
    }
    
    func didReceiveSearchResults(_ results: [MKMapItem]) {
        searchResults = results
        connectionsView.connectionsTableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        print("Search error: \(error.localizedDescription)")
    }
}

// MARK: - UIScrollViewDelegate
extension ConnectionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !connectionsView.fieldsAreActive() {
            let translation = connectionsView.scrollView.panGestureRecognizer.translation(in: connectionsView.scrollView.superview)
            
            if translation.y > 0 {
                connectionsView.forScrollUp()
            } else {
                connectionsView.forScrollDown()
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ConnectionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if fields are active
        if connectionsView.fieldsAreActive() {
            // Determine row count based on searchResults or Core Data
            if let resultsObject = resultsObject {
                return searchResults.isEmpty ? (coreDataManager.getStringArray(from: resultsObject)?.count ?? 0) + 1 : searchResults.count
            } else {
                return searchResults.count
            }
        } else {
            // If fields are not active, base the row count on responseModel and connectionsDataModel
            return connectionsDataModel != nil ? (responseModel?.connection.count ?? 0) : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch connectionsView.fieldsAreActive() {
        case true:
            return CommonSearchLocationTableViewCell.shared.cellForRowWithSearchLocation(in: tableView, at: indexPath, results: searchResults, manager: coreDataManager, from: resultsObject ?? RecentLocations())
        case false:
            return connectionsTableViewCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if connectionsView.fieldsAreActive() {
            updateTableViewHeight(plus: 50.0)
            return CommonSearchLocationTableViewCell.shared.searchLocationCellHeight(indexPath: indexPath)
        } else {
            updateTableViewHeight(plus: 600)
            return 119.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connectionsView.connectionsTableView.deselectRow(at: indexPath, animated: true)
        
        if connectionsView.fieldsAreActive() {
            if !searchResults.isEmpty {
                updateFieldsWithLocation(result: searchResults, saved: [], at: indexPath)
                saveSearchResults(location: searchResults[indexPath.row])
                // post a notification when row is selected, to update touch collection view data for the recent selected rows.
                NotificationCenter.default.post(name: .touchCollectionViewDidUpdate, object: nil)
            } else if let locations = coreDataManager.getStringArray(from: resultsObject ?? RecentLocations()) {
                updateFieldsWithLocation(result: [], saved: locations, at: indexPath)
            }
        }
        
        if connectionsView.fieldsAreActive() && connectionsView.fromField.text != "" && connectionsView.toField.text != "" {
            
            serviceCallForSearchPoints(from: connectionsView.fromField.text ?? "", to: connectionsView.toField.text ?? "", date: selectedDateAndTime?.apiDateString ?? "", time: selectedDateAndTime?.timeString ?? "")
        }
    }
    
    private func tableViweVisibility() {
        if isFetching {
            connectionsView.scrollView.isHidden = true
        } else {
            connectionsView.stopLottieAnimation()
            connectionsView.scrollView.isHidden = false
        }
    }
    
    private func updateTableViewHeight(plus: Double = 0.0) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.connectionsView.tableViewHeight.constant = self.connectionsView.connectionsTableView.contentSize.height + plus
                self.view.layoutIfNeeded()
            }
            self.updateContentViewHeight()
        }
    }
    
    private func updateContentViewHeight() {
        connectionsView.contentViewHeight.constant = connectionsView.connectionsTableView.contentSize.height + 900
    }
    
    private func connectionsTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionsTableViewCell", for: indexPath) as! ConnectionsTableViewCell
        tableView.separatorStyle = .none
        cell.updateData(from: responseModel, indexPath: indexPath)
        return cell
    }
}

// MARK: - GetDateAndTime
extension ConnectionsViewController: GetDateAndTime {
    func selected(date: Date, time: Date, fullDate: Date, callAPI: Bool) {
        // Create an instance of SelectedDateAndTime to format the values
        let selectedDateAndTime = SelectedDateAndTime(date: date, time: time)
        
        // Update UI labels with formatted strings
        connectionsView.dateLbl.text = selectedDateAndTime.shortDateString
        connectionsView.timeLbl.text = selectedDateAndTime.timeString
        connectionsView.fullDateLbl.text = selectedDateAndTime.fullDateString
        
        // Make API call if needed
        if callAPI {
            serviceCallForSearchPoints(
                from: connectionsView.fromField.text ?? "",
                to: connectionsView.toField.text ?? "",
                date: selectedDateAndTime.apiDateString,
                time: selectedDateAndTime.timeString
            )
        }
    }
}
