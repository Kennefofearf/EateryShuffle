//
//  PickedRestaurantViewController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/18/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit
import MapKit

class PickedRestaurantViewController: UIViewController {

    @IBOutlet weak var pickedRestaurantLabel: UILabel!
    
    static let shared = PickedRestaurantViewController()
    
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait)
        
        if RestaurantController.shared.restaurants.count < 1 {
            
            pickedRestaurantLabel.text = "Run a search on the map first!"
        }
        RestaurantController.shared.restaurants.shuffle()
        
        guard let chosenRestaurant = RestaurantController.shared.restaurants.first?.restaurantName else { return }

        pickedRestaurantLabel.text = chosenRestaurant
    }
    
    func openInMaps() {
        
        guard let address = RestaurantController.shared.restaurants.first?.restaurantAddress,
        let name = RestaurantController.shared.restaurants.first?.restaurantName,
        let restaurant = RestaurantController.shared.restaurants.first
            else { return }
        
        CoreDataController.shared.addToHistory(restaurant: restaurant)
        
        if RestaurantController.shared.restaurants.first?.restaurantAddress == "" {
            
            let noAddressAlert = UIAlertController(title: "No street address found!", message: "", preferredStyle: .alert)
            noAddressAlert.addAction(UIAlertAction(title: "Heartbroken", style: .cancel, handler: nil))
            self.present(noAddressAlert, animated: true, completion: nil)
        }
        
        self.geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            
            guard let placemark = placemarks?.first else { return }
            
            let lat = placemark.location?.coordinate.latitude
            let long = placemark.location?.coordinate.longitude
            
            guard let latitude = lat,
                let longitude = long
                else { return }
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let mark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            
            let mapItem = MKMapItem(placemark: mark)
            
            mapItem.name = "\(name)"
            
            let launchOptions = [MKLaunchOptionsDirectionsModeDriving: MKLaunchOptionsDirectionsModeKey]
            mapItem.openInMaps(launchOptions: launchOptions)
        })
    }

    @IBAction func chooseAnotherButtonTapped(_ sender: Any) {
        
        if RestaurantController.shared.restaurants.count > 1 {
            
            RestaurantController.shared.restaurants.removeFirst()
            RestaurantController.shared.restaurants.shuffle()
            
            guard let chosenRestaurant = RestaurantController.shared.restaurants.first?.restaurantName else { return }
            
            pickedRestaurantLabel.text = chosenRestaurant
        } else {
            
            let lastChoiceAlert = UIAlertController(title: "This is the last option!", message: "", preferredStyle: .alert)
            lastChoiceAlert.addAction(UIAlertAction(title: "Fine...", style: .cancel, handler: nil))
            self.present(lastChoiceAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func takeMeThereButtonTapped(_ sender: Any) {
        
        openInMaps()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        
        guard let url = URL(string: "https://www.yelp.com") else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
