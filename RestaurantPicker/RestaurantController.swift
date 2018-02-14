//
//  RestaurantController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/13/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import Foundation

class RestaurantController {
    
    static let shared = RestaurantController()
    
    var restaurants: [Restaurant] = []
    
    static let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")
    
    static func fetchRestaurants(searchTerm: String, completion: @escaping ([Restaurant]) -> Void) {
        
        guard let latitude = MapViewController.shared.locationManager.location?.coordinate.latitude,
            let longitude = MapViewController.shared.locationManager.location?.coordinate.longitude
            else { completion([]); return }
        
        guard let baseURL = baseURL else { completion([]); return }
        
        let headers = ["Authorization":"Bearer YEFxdkctCLmtBYccn4rTEzJbyqr5jk0OMiFQLA80kwP_albjj0gB6dkADpnDuzeiKMQGzKFx83DPlRTArq-b2g3Mdux7aEa8zEHTA1by-QpKYJ5a1xgmYVqPSg-TWXYx"]
        
        let parameters = ["term":"\(MilesAndRadiusController.shared.searchTerm)","latitude":"\(latitude)","longitude":"\(longitude)","radius":"\(MilesAndRadiusController.shared.radius)","limit":"\(50)","price":"\(MilesAndRadiusController.shared.budget)"]
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.flatMap { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else { completion([]); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                completion([])
                return
            }
            
            guard let data = data,
            let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
            let results = jsonDictionary["businesses"] as? [[String: Any]]
            else { completion([]); return }
            
            let restaurants = results.flatMap { Restaurant(dictionary: $0, context: nil) }
            self.shared.restaurants = restaurants
            
            completion(restaurants)
        }
        
        dataTask.resume()
    }
}

extension MutableCollection {
    
    mutating func shuffle() {
        
        let sizeIndex = count
        guard sizeIndex > 1 else { return }
        
        for (firstOrdered, orderedCount) in zip(indices, stride(from: sizeIndex, to: 1, by: -1)) {
            let indexRange: IndexDistance = numericCast(arc4random_uniform(numericCast(orderedCount)))
            guard indexRange != 0 else { continue }
            let originalIndex = index(firstOrdered, offsetBy: indexRange)
            self.swapAt(firstOrdered, originalIndex)
            
        }
        
    }
    
}
