//
//  CoreDataController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/24/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
    
    static let shared = CoreDataController()
    
    func addToHistory(restaurant: Restaurant) {
        
        guard let name = restaurant.restaurantName,
            let time = restaurant.restaurantTimestamp
            else { return }
        
        guard let persistentRestaurant = Restaurant(restaurantName: name, restaurantTimestamp: time as Date) else { return }
            
            
        RecentlyChosenController.shared.recentlyChosen.append(persistentRestaurant)
        
        saveToCoreData()
    }
    
    func saveToCoreData() {
        
        let moc = CoreDataStack.context
        
        do {
            
            try moc.save()
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    func deleteAllCoreData() {
        
        RecentlyChosenController.shared.recentlyChosen.removeAll()
        
        guard let persistentStorage = CoreDataStack.context.persistentStoreCoordinator?.persistentStores.last,
        let url = CoreDataStack.context.persistentStoreCoordinator?.url(for: persistentStorage),
        let persistentContainer = CoreDataStack.context.persistentStoreCoordinator?.persistentStores
            else { return }
        
        CoreDataStack.context.reset()
        do {
        
            for persistentStorage in persistentContainer {
       try CoreDataStack.context.persistentStoreCoordinator?.remove(persistentStorage)
        try FileManager.default.removeItem(at: url)
            try CoreDataStack.context.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            }
        } catch {
            
            NSLog(error.localizedDescription)
        }
            
        saveToCoreData()
    }
    
    func fetchHistory() -> [Restaurant] {
        
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
}
