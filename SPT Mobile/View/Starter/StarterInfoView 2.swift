//
//  StarterInfoView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 25.08.2024.
//

import UIKit

class StarterInfoView: UIView {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var getStartBttn: UIButton!
    @IBOutlet weak var mainView: UIView!
        
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
        setupBlurView()
    }
    
    @IBAction func getStartBttnTap(_ sender: Any) {
        
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("StarterInfoView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupBlurView() {
        blurView.layer.cornerRadius = 12
        blurView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
}
