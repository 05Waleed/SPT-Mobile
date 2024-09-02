//
//  TimetableView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

class TimetableView: UIView {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var toFieldRemover: UIButton!
    @IBOutlet weak var fromFieldRemover: UIButton!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var mainView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadNib()
        setupMainView()
        setupSearchView()
        hideFieldsRemover()
        setTableView()
    }
    
    
    @IBAction func fromFieldRemoverTap(_ sender: Any) {
        fromField.text = ""
        fromField.placeholder = "From"
    }
    
    @IBAction func toFieldRemoverTap(_ sender: Any) {
        toField.text = ""
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("TimetableView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupSearchView() {
        searchView.layer.cornerRadius = 20
        searchView.layer.shadowRadius = 10
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOffset = CGSize(width: 0, height: 5)
        searchView.layer.shadowOpacity = 0.7
    }
    
    private func hideFieldsRemover() {
        fromFieldRemover.isHidden = true
        toFieldRemover.isHidden = true
    }
    
    private func setTableView() {
        connectionTableView.layer.cornerRadius = 20
    }
    
    func fromFieldTextBasedOnFetching(planViewData: PlanViewData?, isFetching: Bool) {
        if isFetching == true {
            fromField.text = "Determining location..."
        } else if planViewData != nil {
            fromField.text = "Current location"
        } else {
            fromField.text = "Insufficient location"
        }
    }
    
    func fromFieldTextBasedOnFocus(planViewData: PlanViewData?) {
        setFieldsRemover()
        if fromField.isFirstResponder {
            if fromField.text == "Current location" || fromField.text == "Insufficient location" {
                fromField.text = ""
                fromField.placeholder = "From"
            }
        } else if toField.isFirstResponder && fromField.text == "" && planViewData != nil {
            fromField.text = "Current location"
        } else if planViewData == nil && fromField.text == "" {
            fromField.text = "Insufficient location"
        }
    }
    
    func setFieldsRemover() {
        if fromField.isFirstResponder {
            fromFieldRemover.isHidden = false
            toFieldRemover.isHidden = true
        } else if toField.isFirstResponder {
            toFieldRemover.isHidden = false
            fromFieldRemover.isHidden = true
        } else {
            toFieldRemover.isHidden = true
            fromFieldRemover.isHidden = true
        }
    }
}
