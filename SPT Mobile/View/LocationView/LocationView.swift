//
//  LocationView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 25.08.2024.
//

import UIKit

class LocationView: UIView {
        
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var allowBttn: UIButton!
    @IBOutlet weak var notNowBttn: UIButton!
    @IBOutlet weak var locationView: UIView!
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
        setupLocationView()
        setupNotNowBttn()
        hideUI()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("LocationView", owner: self)
    }
    
    @IBAction func notNowBttnTap(_ sender: Any) {
       
    }
    
    @IBAction func allowBttnTap(_ sender: Any) {
       
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupLocationView() {
        locationView.backgroundColor = .clear
    }
    
    private func setupNotNowBttn() {
        notNowBttn.layer.borderWidth = 3
        notNowBttn.layer.cornerRadius = 25
        notNowBttn.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
    }
    
    func hideUI() {
        notNowBttn.isHidden = true
        allowBttn.isHidden = true
        locationLbl.isHidden = true
    }
    
    func showUI() {
        notNowBttn.alpha = 0
        allowBttn.alpha = 0
        locationLbl.alpha = 0
        locationLbl.isHidden = false
        notNowBttn.isHidden = false
        allowBttn.isHidden = false
        
        UIView.animate(withDuration: 1) {
            self.locationLbl.alpha = 1
            self.notNowBttn.alpha = 1
            self.allowBttn.alpha = 1
        }
    }
}

