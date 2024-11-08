//
//  JourneyInformationViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 06.09.2024.
//

import UIKit

class JourneyInformationViewController: UIViewController {

    var leg: Leg?
    
    @IBOutlet var journeyView: JourneyInformationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        updateUI()
        conformDelegates()
        registerXib()
    }
    
    private func setNavBar() {
        title = "Journey Information"
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    private func conformDelegates() {
        journeyView.journeyTableView.dataSource = self
        journeyView.journeyTableView.delegate = self
    }
    
    private func registerXib() {
        journeyView.journeyTableView.register(UINib(nibName: "JourneyHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "JourneyHeaderTableViewCell")
        
        journeyView.journeyTableView.register(UINib(nibName: "JourneyMiddleTableViewCell", bundle: nil), forCellReuseIdentifier: "JourneyMiddleTableViewCell")
        
        journeyView.journeyTableView.register(UINib(nibName: "JourneyLastTableViewCell", bundle: nil), forCellReuseIdentifier: "JourneyLastTableViewCell")
    }
    
    private func updateTableViewHeight() {
        let tableViewHeight = journeyView.journeyTableView.contentSize.height
        journeyView.tableViewHeight.constant = tableViewHeight + 110
        updateContentViewHeight()
    }
    
    private func updateContentViewHeight() {
        let tableViewHeight = journeyView.journeyTableView.contentSize.height
        journeyView.contentViewHeight.constant = tableViewHeight + 1000
    }
    
    func updateUI() {
        DispatchQueue.main.async { [self] in
            if let leg = leg,
               let g = leg.g,
               let l = leg.l,
               let z = leg.z,
               let terminal = leg.terminal,
               let type = leg.type {
                journeyView.updateLineLbl(line: "\(g) \(l) \(z)")
                journeyView.updateVehicleImg(type: type, img: journeyView.vehicleImg)
                journeyView.updateDirection(direction: "Direction \(terminal)")
            }
        }
    }
}

extension JourneyInformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (leg?.stops?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowCount = tableView.numberOfRows(inSection: indexPath.section)
        
        if leg?.stops?.count == 0 {
            return lastCell(tableView, cellForRowAt: indexPath)
        } else {
            switch indexPath.row {
            case 0:
                return headerCell(tableView, cellForRowAt: indexPath)
            case rowCount - 1:
                return lastCell(tableView, cellForRowAt: indexPath)
            default:
                return middleCell(tableView, cellForRowAt: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
        
        switch indexPath.row {
        case lastRow:
            return 158
        default:
            return 125
        }
    }
    
    func headerCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyHeaderTableViewCell") as! JourneyHeaderTableViewCell
        updateTableViewHeight()
        
        if let leg = leg {
            cell.updateUI(leg: leg)
        }
        
        return cell
    }
    
    func middleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyMiddleTableViewCell") as! JourneyMiddleTableViewCell
        updateTableViewHeight()
        
        cell.updateData(stop: (leg?.stops)!, at: indexPath)
        return cell
    }
    
    func lastCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyLastTableViewCell") as! JourneyLastTableViewCell
        updateTableViewHeight()
        
        cell.updateFinalData(leg: leg!, stop: (leg?.stops)!)
        return cell
    }
}
