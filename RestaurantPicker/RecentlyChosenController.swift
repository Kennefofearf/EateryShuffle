//
//  RecentlyChosenController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/24/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import Foundation

class RecentlyChosenController {
    
    static let shared = RecentlyChosenController()
    
    var recentlyChosen: [Restaurant] = []
    
    init() {
        
        self.recentlyChosen = CoreDataController.shared.fetchHistory()
    }
}
