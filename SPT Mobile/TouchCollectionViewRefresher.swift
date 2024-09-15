//
//  TouchCollectionViewRefresher.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 15.09.2024.
//

import Foundation

struct TouchCollectionViewRefresher {
    func refreshData() {
        // Notify other view controllers about the update
        NotificationCenter.default.post(name: .touchCollectionViewDidUpdate, object: nil)
    }
}

extension Notification.Name {
    static let touchCollectionViewDidUpdate = Notification.Name("touchCollectionViewDidUpdate")
}
