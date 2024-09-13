//
//  RecentLocations+CoreDataProperties.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 13.09.2024.
//
//

import Foundation
import CoreData


extension RecentLocations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentLocations> {
        return NSFetchRequest<RecentLocations>(entityName: "RecentLocations")
    }

    @NSManaged public var recentLocation: Data?

}

extension RecentLocations : Identifiable {

}
