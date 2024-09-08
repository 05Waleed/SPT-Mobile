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
    
    var locationModel: LocationModel?
    var planViewData: PlanViewData?
    var isFetching: Bool = true
    var searchResults: [MKMapItem] = []
    private let locationSearchManager = LocationSearchManager()
    
    @IBOutlet weak var timetableView: TimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureDelegates()
        timetableView.updateView(isFetching: isFetching, planViewData: planViewData)
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
            "CurrentLocationTableViewCell"
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
        planViewData = PlanViewData(connection: allConnections, legs: allLegs, stop: allStops)
        timetableView.updateView(isFetching: isFetching, planViewData: planViewData)
        timetableView.connectionTableView.reloadData()
    }
    
    private func handleServiceError() {
        isFetching = false
        timetableView.updateView(isFetching: isFetching, planViewData: planViewData)
        timetableView.connectionTableView.reloadData()
    }
    
    private func fieldsAreActive() -> Bool {
        timetableView.fromField.isFirstResponder || timetableView.toField.isFirstResponder
    }
    
    private func navigateToJourneyInformationVc(indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "JourneyInformationViewController") as? JourneyInformationViewController else { return }
        vc.leg = planViewData?.legs?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
        
    private func updateFieldsWithLocation(result: [MKMapItem], at indexPath: IndexPath) {
        let selectedLocation = result[indexPath.row].name
        if timetableView.fromField.isFirstResponder {
            timetableView.fromField.text = selectedLocation
            if timetableView.toField.text?.isEmpty == true {
                timetableView.toField.becomeFirstResponder()
            }
        } else if timetableView.toField.isFirstResponder {
            timetableView.toField.text = selectedLocation
            if timetableView.fromField.text?.isEmpty == true {
                timetableView.fromField.becomeFirstResponder()
            }
        }
    }
    
    func removeSearchResults() {
        searchResults.removeAll()
        timetableView.connectionTableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension PlanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timetableView.fromField {
            timetableView.configureViewForSearchLocation()
            updateTableViewHeight(plus: 50)
            timetableView.updateFromFieldTextBasedOnFocus(planViewData: planViewData)
            timetableView.fromField.returnKeyType = .next
        } else if textField == timetableView.toField {
            timetableView.configureViewForSearchLocation()
            timetableView.updateFromFieldTextBasedOnFocus(planViewData: planViewData)
            timetableView.toField.returnKeyType = .search
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == timetableView.fromField {
            timetableView.toField.becomeFirstResponder()
        } else if textField == timetableView.toField {
            if timetableView.fromField.text?.isEmpty == true {
                timetableView.fromField.becomeFirstResponder()
            } else {
                // Perform navigation or other actions
                print("Navigation performed")
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
        guard let url = NetworkManager.shared.setupURL(from: "\(locationModel?.cityName ?? "") \(locationModel?.streetName ?? "")", to: locationModel?.cityName ?? "") else { return }
        
        NetworkManager.shared.performRequest(with: url, isFetching: { [weak self] isLoading in
            self?.isFetching = isLoading
        }, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataModel):
                    self?.handleServiceResponse(dataModel)
                case .failure(let error):
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
            return searchResults.isEmpty ? 1 : searchResults.count
        } else {
            return isFetching ? 2 : (planViewData?.legs?.count ?? 2)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fieldsAreActive() {
            return TableViewCellManager.shared.cellForRowWithSearchLocation(in: tableView, at: indexPath, results: searchResults)
        } else {
            if isFetching {
                return TableViewCellManager.shared.cellForRowWhileFetching(in: tableView, at: indexPath)
            } else if let planViewData = planViewData {
                return TableViewCellManager.shared.cellForRowWhileUpdatingData(in: tableView, at: indexPath, planViewData: planViewData)
            } else {
                return TableViewCellManager.shared.cellForRowWithError(in: tableView, at: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fieldsAreActive() {
            updateTableViewHeight(plus: 50.0)
            return TableViewCellManager.shared.searchLocationCellHeight()
        } else {
            if isFetching {
                updateTableViewHeight()
                return TableViewCellManager.shared.heightForRowWhileFetching(in: tableView, at: indexPath)
            } else if let legs = planViewData?.legs, indexPath.row < legs.count {
                updateTableViewHeight()
                return TableViewCellManager.shared.heightForRowWhileUpdatingData(in: tableView, at: indexPath, leg: planViewData?.legs?[indexPath.row])
            } else {
                updateTableViewHeight()
                return TableViewCellManager.shared.errorCellHeight(in: tableView, at: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timetableView.connectionTableView.deselectRow(at: indexPath, animated: true)
        
        if fieldsAreActive() {
            if !searchResults.isEmpty {
                updateFieldsWithLocation(result: searchResults, at: indexPath)
            }
        } else if indexPath.row > 0 {
            navigateToJourneyInformationVc(indexPath: indexPath)
        }
    }
}
