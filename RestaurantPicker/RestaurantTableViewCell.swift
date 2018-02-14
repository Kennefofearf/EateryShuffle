//
//  RestaurantTableViewCell.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/17/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var reviewButtonLabel: UIButton!
    
    var restaurant: Restaurant? {
        
        didSet {
            
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let restaurant = restaurant else { return }
        
         if restaurant.restaurantRating < 1.0 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_0")
        } else if restaurant.restaurantRating < 1.5 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_1")
        } else if restaurant.restaurantRating < 2.0 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_1_half")
         } else if restaurant.restaurantRating < 2.5 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_2")
         } else if restaurant.restaurantRating < 3.0 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_2_half")
         } else if restaurant.restaurantRating < 3.5 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_3")
         } else if restaurant.restaurantRating < 4.0 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_3_half")
         } else if restaurant.restaurantRating < 4.5 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_4")
         } else if restaurant.restaurantRating < 5.0 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_4_half")
         } else if  restaurant.restaurantRating == 5.0 {
            
            starsImageView.image = #imageLiteral(resourceName: "small_5")
         } else {
            
            starsImageView.image = #imageLiteral(resourceName: "small_0")
        }
        
        restaurantNameLabel.text = restaurant.restaurantName
        restaurantAddressLabel.text = restaurant.restaurantAddress
        reviewButtonLabel.setTitle("\(restaurant.restaurantReviewCount) Reviews...", for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }
   
    @objc func tapped(gesture: UIGestureRecognizer) {
        
        guard let restaurant = restaurant else { return }
        
        RestaurantController.shared.restaurants.removeFirst()
        RestaurantController.shared.restaurants.insert(restaurant, at: 0)
        
        PickedRestaurantViewController.shared.openInMaps()
    }
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        
        guard let restaurant = restaurant,
        let url = URL(string: "https://www.yelp.com/biz/\(restaurant.restaurantID ?? "")")
            else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        
        guard let url = URL(string: "https://www.yelp.com") else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

