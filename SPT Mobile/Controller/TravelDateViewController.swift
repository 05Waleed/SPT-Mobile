//
//  TravelDateViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 03.11.2024.
//

import UIKit

class TravelDateViewController: UIViewController {
    
    @IBOutlet var travelDateView: TravelDateView!
    weak var delegate: GetDateAndTime?
    var selectedDateAndTime: SelectedDateAndTime?

    override func viewDidLoad() {
        super.viewDidLoad()
        conform()
    }
    
    private func conform() {
        travelDateView.travelDateViewController = self
    }
    
    func hide() {
        dismiss(animated: true)
    }
    func sendDelegate() {
        delegate?.selected(date: travelDateView.datePicker.date, time: travelDateView.datePicker.date, fullDate: travelDateView.datePicker.date, callAPI: true)
        hide()
    }
}
