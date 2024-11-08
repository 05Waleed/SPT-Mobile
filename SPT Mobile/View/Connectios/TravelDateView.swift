//
//  TravelDateView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 03.11.2024.
//

import UIKit

class TravelDateView: UIView {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var segmentView: SegmentView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var closeBttn: UIButton!
    @IBOutlet weak var contantView: UIView!
    
    weak var travelDateViewController: TravelDateViewController?
    
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
        configView()
        setupSegmentView()
        setupDatePicker()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("TravelDateView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func configView() {
        contantView.layer.cornerRadius = 20
        dateView.layer.cornerRadius = 20
    }
    
    private func setupSegmentView() {
        backView.backgroundColor = .datePickerBackground
        segmentView.numberOfSegments = 2
        segmentView.segmentsTitle = "Departure,Arrival"
        segmentView.currentIndexTitleColor = .label
        segmentView.otherIndexTitleColor = .label
        segmentView.backgroundColor = .datePicker
        segmentView.currentIndexBackgroundColor = .content
    }
    
     func setupDatePicker() {
        datePicker.minimumDate = .now
        datePicker.minuteInterval = 5
    }
    
    @IBAction func closeBttnTap(_ sender: Any) {
        travelDateViewController?.hide()
    }
    
    @IBAction func acceptBttnTap(_ sender: Any) {
        travelDateViewController?.sendDelegate()
    }
}
