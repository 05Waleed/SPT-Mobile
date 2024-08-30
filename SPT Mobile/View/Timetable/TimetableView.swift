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
    }
    
    @IBAction func fromFieldRemoverTap(_ sender: Any) {
        
    }
    
    @IBAction func toFieldRemoverTap(_ sender: Any) {
        
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
    
}
