//
//  CoreDataManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 13.09.2024.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecentLocations")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Fetch Results Object
    func fetchResults() -> RecentLocations? {
        let fetchRequest: NSFetchRequest<RecentLocations> = RecentLocations.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Return the first result if it exists
        } catch {
            print("Failed to fetch Results object: \(error)")
            return nil
        }
    }

    // MARK: - Save String Array to Results Object
    func saveStringArray(_ stringArray: [String], to object: RecentLocations) {
        do {
            let data = try JSONEncoder().encode(stringArray)
            object.recentLocation = data
            saveContext() // Save the Core Data context
        } catch {
            print("Failed to encode and save string array: \(error)")
        }
    }

    // MARK: - Decode String Array from Results Object
    func getStringArray(from object: RecentLocations) -> [String]? {
        if let data = object.recentLocation {
            do {
                let stringArray = try JSONDecoder().decode([String].self, from: data)
                return stringArray
            } catch {
                print("Failed to decode string array: \(error)")
            }
        }
        return nil
    }
}

