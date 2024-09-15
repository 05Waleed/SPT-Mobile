//
//  TouchTimetableViewController.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 15.09.2024.
//

import UIKit

import UIKit

class TouchTimetableViewController: UIViewController {
    
    var screenWidht: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private let coreDataManager = CoreDataManager.shared
    private var resultsObject: RecentLocations?
    
    @IBOutlet var touchTimetableView: TouchTimetableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchSearchResults()
        checkNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .touchCollectionViewDidUpdate, object: nil)
    }
    
    private func setupView() {
        touchTimetableView.touchCollectionView.delegate = self
        touchTimetableView.touchCollectionView.dataSource = self
        
        touchTimetableView.touchCollectionView.register(
            UINib(nibName: "RecentSearchedLocationsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "RecentSearchedLocationsCollectionViewCell"
        )
    }
    
    private func fetchSearchResults() {
        resultsObject = coreDataManager.fetchResults() ?? RecentLocations(context: coreDataManager.context)
        collectionViewHeight()
    }
    
    private func collectionViewHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.touchTimetableView.touchCollectionViewHeight.constant = self.touchTimetableView.touchCollectionView.contentSize.height
        }
    }
}


extension TouchTimetableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RecentSearchedLocationsCollectionViewCell", for: indexPath) as! RecentSearchedLocationsCollectionViewCell
        
        let defaultLocations = DefaultLocations()
        let recentLocations = coreDataManager.getStringArray(from: resultsObject ?? RecentLocations()) ?? [String]()
        cell.updateLocation(recentLocations: recentLocations, defaultLocations: defaultLocations, at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        touchTimetableView.touchCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if screenWidht <= 390.0 {
            return sizeFor390(at: indexPath)
        } else {
            return sizeForGreaterThan390(at: indexPath)
        }
    }
    
    private func sizeFor390(at indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 11,12:
            return CGSize(width: 93, height: 90)
        default:
            return CGSize(width: 186, height: 90)
        }
    }
    
    private func sizeForGreaterThan390(at indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 11,12:
            return CGSize(width: 103, height: 90)
        default:
            return CGSize(width: 206, height: 90)
        }
    }
}

extension TouchTimetableViewController {
    private func checkNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRowSelection(_:)),
            name: .touchCollectionViewDidUpdate,
            object: nil
        )
    }
    
    @objc private func handleRowSelection(_ notification: Notification) {
        touchTimetableView.touchCollectionView.reloadData()
    }
}
