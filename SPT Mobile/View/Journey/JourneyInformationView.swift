//
//  JourneyInformationView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 06.09.2024.
//

import UIKit

class JourneyInformationView: UIView {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var journeyTableView: UITableView!
    @IBOutlet weak var directionLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var vehicleImg: UIImageView!
    @IBOutlet weak var headerView: UIView!
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
        setCorners()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("JourneyInformationView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setCorners() {
        headerView.layer.cornerRadius = 10
        headerView.layer.shadowRadius = 10
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        headerView.layer.shadowOpacity = 0.7
        
        journeyTableView.layer.cornerRadius = 10
    }
    
    func updateLineLbl(line: String) {
        lineLbl.text = line
    }
    
    func updateDirection(direction: String) {
        directionLbl.text = direction
    }
    
    func updateVehicleImg(type: String, img: UIImageView) {
        img.layer.cornerRadius = 2
        if type == "bus" {
            img.image = UIImage(named: "bus 1")
        } else if type == "bus" {
            img.image = UIImage(named: "strain")
        }  else if type == "strain" {
            img.image = UIImage(named: "tram")
        }  else {
            img.image = UIImage(named: "dot")
        }
    }
}
