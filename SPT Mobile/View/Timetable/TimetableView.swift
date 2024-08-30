//
//  TimetableView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 30.08.2024.
//

import UIKit

class TimetableView: UIView {
    
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
    }
    
     func hideFieldsRemover() {
        fromFieldRemover.isHidden = true
        toFieldRemover.isHidden = true
    }
    
     func showFieldsRemover() {
        fromFieldRemover.isHidden = false
        toFieldRemover.isHidden = false
    }
}
