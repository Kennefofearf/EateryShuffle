//
//  Restaurant+Convenience.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/14/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import Foundation
import CoreData

extension Restaurant {
    
    convenience init?(dictionary: [String:Any],
                     context: NSManagedObjectContext? = CoreDataStack.context) {
        
        
        if let context = context {
            self.init(context: context)
        } else {
            self.init(entity: Restaurant.entity(), insertInto: nil)
        }
        
        nameKey = "name"
        ratingKey = "rating"
        addressKey = "address1"
        latKey = "latitude"
        longKey = "longitude"
        idKey = "id"
        reviewCountKey = "review_count"
        restaurantTimestamp = Date()
    
        guard let nameKey = nameKey,
            let ratingKey = ratingKey,
            let addressKey = addressKey,
            let latKey = latKey,
            let longKey = longKey,
            let idKey = idKey,
            let reviewCountKey = reviewCountKey
            else { return }
        
        guard let restaurantName = dictionary[nameKey] as? String,
        let restaurantID = dictionary[idKey] as? String,
        let restaurantReviewCount = dictionary[reviewCountKey] as? Int,
        let restaurantRating = dictionary[ratingKey] as? Double,
        let address = dictionary["location"] as? [String:Any],
        let restaurantAddress = address[addressKey] as? String,
        let coordinates = dictionary["coordinates"] as? [String:Any],
        let restaurantLat = coordinates[latKey] as? NSObject,
        let restaurantLong = coordinates[longKey] as? NSObject
            else { return nil }
        
        self.restaurantName = restaurantName
        self.restaurantRating = restaurantRating
        self.restaurantAddress = restaurantAddress
        self.restaurantLat = restaurantLat
        self.restaurantLong = restaurantLong
        self.restaurantID = restaurantID
        self.restaurantReviewCount = Int64(restaurantReviewCount)
    }
    
    
    convenience init?(restaurantName: String,
                      restaurantTimestamp: Date,
                      context: NSManagedObjectContext? = CoreDataStack.context) {
        
        
        if let context = context {
            self.init(context: context)
        } else {
            self.init(entity: Restaurant.entity(), insertInto: nil)
        }
        
        self.restaurantName = restaurantName
        self.restaurantTimestamp = restaurantTimestamp as Date

    }
}
