//
//  ConnectionsView.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 16.09.2024.
//

import UIKit

class ConnectionsView: UIView {
    
    // MARK: - Properties
    var currentRotation: CGFloat = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateLblTop: NSLayoutConstraint!
    @IBOutlet weak var lineView5: UIView!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var dateLblLeading: NSLayoutConstraint!
    @IBOutlet weak var lineView4: UIView!
    @IBOutlet weak var lineImg3: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var dotImg1: UIImageView!
    @IBOutlet weak var dotImg2: UIImageView!
    @IBOutlet weak var reloaderBttn: UIButton!
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldsSwapperImg: UIImageView!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toFieldRemover: UIButton!
    @IBOutlet weak var fromFieldRemover: UIButton!
    @IBOutlet weak var detailedDateView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var connectionsTableView: UITableView!
    
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
        hideFieldBttns()
        setTableView()
        tapGestureToSwapper()
        setupView(view: headerView)
        setupView(view: detailedDateView, shadowOpacity: 0.4, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        startLottieAnimation()
        tableViewTop.constant = 170
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("ConnectionsView", owner: self)
    }
    
    private func setupMainView() {
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setTableView() {
        connectionsTableView.layer.cornerRadius = 20
    }
    
    func setupView(view: UIView, cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 10, shadowColor: UIColor = .black, shadowOffset: CGSize = CGSize(width: 0, height: 5), shadowOpacity: Float = 0.2, maskedCorners: CACornerMask? = nil) {
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = shadowOpacity
        
        if let corners = maskedCorners {
            view.layer.maskedCorners = corners
        }
    }
    
    // MARK: - Text Field Button Visibility
    func hideFieldBttns() {
        fromFieldRemover.isHidden = true
        toFieldRemover.isHidden = true
    }
    
    func showFieldBttns() {
        fromFieldRemover.isHidden = false
        toFieldRemover.isHidden = false
    }
    
    // MARK: - Gesture Handling
    func tapGestureToSwapper() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        fieldsSwapperImg.isUserInteractionEnabled = true
        fieldsSwapperImg.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {
        swapFieldsWithAnimation()
    }
    
    // MARK: - Field Swap Animation
    private func swapFieldsWithAnimation() {
        guard let fromText = fromField.text, let toText = toField.text else { return }
        currentRotation += .pi
        
        UIView.animate(withDuration: 0.2, animations: {
            self.fieldsSwapperImg.transform = CGAffineTransform(rotationAngle: self.currentRotation)
            self.toField.transform = CGAffineTransform(translationX: 0, y: -self.toField.frame.height)
            self.fromField.transform = CGAffineTransform(translationX: 0, y: self.fromField.frame.height)
            self.toField.alpha = 0
        }) { _ in
            self.fromField.text = toText
            self.toField.text = fromText
            self.toField.alpha = 1
            self.fromField.alpha = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.fromField.transform = .identity
                self.toField.transform = .identity
                self.fromField.alpha = 1
            })
        }
    }
    
    // MARK: - Swapper Visibility Logic
    func hideSwapper() {
        UIView.animate(withDuration: 0.3, animations: {
            self.fieldsSwapperImg.transform = CGAffineTransform(translationX: self.fieldsSwapperImg.frame.width, y: 0)
            self.fieldsSwapperImg.alpha = 0
        }) { _ in
            self.fieldsSwapperImg.isHidden = true
        }
    }
    
    func showSwapper() {
        fieldsSwapperImg.transform = CGAffineTransform(translationX: fieldsSwapperImg.frame.width, y: 0)
        fieldsSwapperImg.alpha = 0
        fieldsSwapperImg.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.fieldsSwapperImg.transform = .identity
            self.fieldsSwapperImg.alpha = 1
        }
    }
    
    // MARK: - Button Actions
    @IBAction func toFieldRemoverBttnTap(_ sender: Any) {
        toField.text = ""
        toField.becomeFirstResponder() // Set focus to the toField
    }
    
    @IBAction func fromFieldRemoverBttnTap(_ sender: Any) {
        fromField.text = ""
        fromField.becomeFirstResponder() // Set focus to the fromField
    }
    
    @IBAction func reloaderBttnTap(_ sender: Any) {
        
    }
    
    
    // MARK: - End Editing on Touch Outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.endEditing(true)
    }
    
    func fieldsAreActive() -> Bool {
        fromField.isFirstResponder || toField.isFirstResponder
    }
    
    func updateFields(connectionsDataModel: ConnectionsDataModel) {
        fromField.text = connectionsDataModel.fromText
        toField.text = connectionsDataModel.toText
    }
    
    func startLottieAnimation() {
        LottieManager.shared.startAnimation(on: loaderView, animationName: "LoaderIndicator", animationSpeed: 2.0, loopMode: .loop) {
            print("")
        }
    }
    
    func stopLottieAnimation() {
        LottieManager.shared.stopAnimation()
    }
    
    func forScrollDown() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerViewHeight.constant = 60
                self.mainView.layoutIfNeeded()
            }, completion: { _ in
                // Hide elements after the animation completes
                self.fromField.isHidden = true
                self.toField.isHidden = true
                self.dotImg1.isHidden = true
                self.dotImg2.isHidden = true
                self.lineView1.isHidden = true
                self.lineView2.isHidden = true
                self.lineImg3.isHidden = true
                self.lineView4.isHidden = true
                self.lineView5.isHidden = true
                self.timeLbl.isHidden = true
                self.reloaderBttn.isHidden = true
                self.fieldsSwapperImg.isHidden = true
                
                self.dateLbl.textAlignment = .left
                self.dateLbl.textColor = .label
                self.dateLbl.font = .systemFont(ofSize: 17, weight: .bold)
            })
        }
        
        dateLblTop.constant = -77
        tableViewTop.constant = 65
        dateLblLeading.constant = 16
    }
    
    func forScrollUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerViewHeight.constant = 138
                self.mainView.layoutIfNeeded()
            }, completion: { _ in
                // Show elements after the animation completes
                self.fromField.isHidden = false
                self.toField.isHidden = false
                self.dotImg1.isHidden = false
                self.dotImg2.isHidden = false
                self.lineView1.isHidden = false
                self.lineView2.isHidden = false
                self.lineImg3.isHidden = false
                self.lineView4.isHidden = false
                self.lineView5.isHidden = false
                self.reloaderBttn.isHidden = false
                self.fieldsSwapperImg.isHidden = false
                self.timeLbl.isHidden = false
                
                self.dateLbl.textAlignment = .center
                self.dateLbl.textColor = .systemGray
                self.dateLbl.font = .systemFont(ofSize: 15, weight: .regular)
            })
        }
        
        dateLblTop.constant = 8
        tableViewTop.constant = 150
        dateLblLeading.constant = 41
    }
}

