//
//  TouchTimetableView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 09.09.2024.
//

import UIKit

class TouchTimetableView: UIView {

    @IBOutlet weak var touchCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var touchCollectionView: UICollectionView!
    
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
        setTouchCollectionView()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("TouchTimetableView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setTouchCollectionView() {
        touchCollectionView.layer.cornerRadius = 20
    }
}
