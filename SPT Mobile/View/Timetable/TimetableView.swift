//
//  TimetableView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

class TimetableView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var scrollView: UIView!
    @IBOutlet private weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet private weak var toFieldRemover: UIButton!
    @IBOutlet private weak var fromFieldRemover: UIButton!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private var mainView: UIView!
    
    weak var planViewController: PlanViewController?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Setup Methods
    
    private func commonInit() {
        loadNib()
        setupMainView()
        setupSearchView()
        hideFieldRemovers()
        configureTableView()
        setupGestureRecognizer()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("TimetableView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupSearchView() {
        searchView.layer.cornerRadius = 20
        searchView.layer.shadowRadius = 10
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOffset = CGSize(width: 0, height: 5)
        searchView.layer.shadowOpacity = 0.7
    }
    
    private func configureTableView() {
        connectionTableView.layer.cornerRadius = 20
    }

    // MARK: - Gesture Recognizer Setup
    
    private func setupGestureRecognizer() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         tapGesture.delegate = self
         scrollView.addGestureRecognizer(tapGesture)
     }
     
     // Delegate method to ensure the gesture recognizer doesn't block table view interactions
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         // Only dismiss the keyboard if the tap is outside the table view
         return !connectionTableView.frame.contains(touch.location(in: self))
     }

     @objc private func dismissKeyboard() {
         fromField.resignFirstResponder()
         toField.resignFirstResponder()
         resetViewAppearance()
     }

    
    // MARK: - Update View Methods
    
    func configureViewForSearchLocation() {
            backView.backgroundColor = UIColor(named: "ConnectionTableViewColor")
            connectionTableView.backgroundColor = UIColor(named: "ConnectionTableViewColor")
            scrollView.backgroundColor = UIColor(named: "ScrollViewColor")
            connectionTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            connectionTableView.reloadData()
        }
    
    func updateView(isFetching: Bool, planViewData: PlanViewData?) {
        fromField.text = isFetching ? "Determining location..." : (planViewData != nil ? "Current location" : "Insufficient location")
    }
    
    func updateFromFieldTextBasedOnFocus(planViewData: PlanViewData?) {
        setFieldRemoverVisibility()
        if fromField.isFirstResponder {
            handleFromFieldFocus(planViewData: planViewData)
        } else if toField.isFirstResponder {
            handleToFieldFocus(planViewData: planViewData)
        }
    }
    
    // MARK: - Field Focus Handlers
    
    private func handleFromFieldFocus(planViewData: PlanViewData?) {
        if ["Current location", "Insufficient location"].contains(fromField.text) {
            fromField.text = ""
            fromField.placeholder = "From"
        }
    }
    
    private func handleToFieldFocus(planViewData: PlanViewData?) {
        if fromField.text?.isEmpty == true {
            fromField.text = planViewData != nil ? "Current location" : "Insufficient location"
        }
    }
    
    // MARK: - Field Remover Visibility
    
    private func setFieldRemoverVisibility() {
        fromFieldRemover.isHidden = !fromField.isFirstResponder
        toFieldRemover.isHidden = !toField.isFirstResponder
    }
    
    private func hideFieldRemovers() {
        fromFieldRemover.isHidden = true
        toFieldRemover.isHidden = true
    }
    
    // MARK: - Field Clearing
    
    private func clearFromField() {
        fromField.text = ""
        fromField.placeholder = "From"
    }
    
    private func clearToField() {
        toField.text = ""
    }
    
    @IBAction private func fromFieldRemoverTap(_ sender: Any) {
        clearFromField()
        planViewController?.removeSearchResults()
    }
    
    @IBAction private func toFieldRemoverTap(_ sender: Any) {
        clearToField()
        planViewController?.removeSearchResults()
    }
    
    // MARK: - Reset View Appearance After Gesture
    
    private func resetViewAppearance() {
        connectionTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backView.backgroundColor = .clear
        scrollView.backgroundColor = .mainTheme
        hideFieldRemovers()
        fromField.text = "Current location"
        clearToField()
        connectionTableView.reloadData()
    }
}
