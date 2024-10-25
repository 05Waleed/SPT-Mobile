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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformProtocols()
        registerXib()
        connectionsView.updateFields(connectionsDataModel: connectionsDataModel ?? ConnectionsDataModel(fromText: "", toText: "", currentText: ""))
        registerForKeyboardNotifications()
        tableViweVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        serviceCallFromSelectedLocation()
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
    }
    
    private func registerXib() {
        let nibNames = [
            "SearchLocationTableViewCell",
            "ConnectionsTableViewCell"
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
    }
    
    private func handleServiceError(error: Error) {
        isFetching = false
        tableViweVisibility()
        print("Service call error: \(error)")
        connectionsView.connectionsTableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension ConnectionsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        connectionsView.showFieldBttns() // Show field buttons when editing begins
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        connectionsView.hideFieldBttns() // Hide field buttons when editing ends
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == connectionsView.fromField {
            connectionsView.toField.becomeFirstResponder()
        } else if textField == connectionsView.toField {
            if connectionsView.fromField.text?.isEmpty == true {
                connectionsView.fromField.becomeFirstResponder()
            } else {
                // Perform navigation or other actions
                print("Navigation performed")
            }
        }
        return false
    }
}

// MARK: - Network Call
extension ConnectionsViewController {
    private func serviceCallFromSelectedLocation() {
        // Construct the URL for the network call.
        
        var fromText = ""
        if connectionsDataModel?.fromText == "Current location" {
            fromText = connectionsDataModel?.currentText ?? ""
        } else {
            fromText = connectionsDataModel?.fromText ?? ""
        }
        
        guard let url = NetworkManager.shared.setupURL(from: fromText, to: connectionsDataModel?.toText ?? "") else { return }
        
        // Call the generic performRequest method, specifying the expected data model.
        NetworkManager.shared.performRequest(with: url, isFetching: { [weak self] isLoading in
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

extension ConnectionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = connectionsView.scrollView.panGestureRecognizer.translation(in: connectionsView.scrollView.superview)
        
        if translation.y > 0 {
            connectionsView.forScrollUp()
        } else {
            connectionsView.forScrollDown()
        }
    }
}

extension ConnectionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connectionsDataModel != nil {
            return responseModel?.connection.count ?? 0
        } else if connectionsView.fieldsAreActive() {
            return searchResults.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionsTableViewCell", for: indexPath) as! ConnectionsTableViewCell
        tableView.separatorStyle = .none
        cell.updateData(from: responseModel, indexPath: indexPath)
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseModel != nil {
            updateTableViewHeight()
            return 119.0
        } else if connectionsView.fieldsAreActive() {
            return 50
        } else {
            return 0
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
    
    private func updateTableViewHeight() {
        connectionsView.tableViewHeight.constant = connectionsView.connectionsTableView.contentSize.height + 200
        updateContentViewHeight()
    }
    
    private func updateContentViewHeight() {
        connectionsView.contentViewHeight.constant = connectionsView.connectionsTableView.contentSize.height + 900
    }
}
