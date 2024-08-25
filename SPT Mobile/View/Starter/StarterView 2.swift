//
//  StarterView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 25.08.2024.
//

import UIKit

class StarterView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var trainAnimationView: UIView!
    
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
        setupTrainView()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("StarterView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupTrainView() {
        trainAnimationView.backgroundColor = .clear
    }
}
