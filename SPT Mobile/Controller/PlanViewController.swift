//
//  PlanViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

class PlanViewController: UIViewController {
    
    @IBOutlet weak var timetableView: TimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conformProtocols()
    }
    
    private func conformProtocols() {
        timetableView.fromField.delegate = self
        timetableView.toField.delegate = self
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
