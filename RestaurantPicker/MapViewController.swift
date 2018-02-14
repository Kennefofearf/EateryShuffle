//
//  MapViewController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/13/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var restaurantMapView: MKMapView!
    @IBOutlet weak var restaurantListButton: UIBarButtonItem!
    
    static let shared = MapViewController()
    
    var geocoder = CLGeocoder()
    static var annotations: [MKPointAnnotation] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait)
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            self.restaurantMapView.showsUserLocation = true
            let user = MKUserTrackingMode.follow
            self.restaurantMapView.userTrackingMode = user
            
            let lat = restaurantMapView.userLocation.coordinate.latitude
            let long = restaurantMapView.userLocation.coordinate.longitude
            let zoomLat: CLLocationDegrees = 1.2
            let zoomLong: CLLocationDegrees = 1.2
            let span: MKCoordinateSpan = MKCoordinateSpanMake(zoomLat, zoomLong)
            let location = CLLocationCoordinate2DMake(lat, long)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.restaurantMapView.setRegion(region, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        search()
    }
    
    func mapView(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinID = "place"
        var pinView: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            pinView = dequeuedView
        } else {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinID)
        }
        
        return pinView
    }
    
    func search() {
        
        var pinArray: [MKPointAnnotation] = []
        
        DispatchQueue.main.async {
        if self.restaurantMapView.annotations.isEmpty != true {
            
                self.restaurantMapView.removeAnnotations(self.restaurantMapView.annotations)
            }
        }
        
        pinArray.removeAll()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.restaurants = []
        
        RestaurantController.fetchRestaurants(searchTerm: "\(MilesAndRadiusController.shared.searchTerm)") { (restaurants) in
            
            RestaurantController.shared.restaurants = restaurants
            
            for restaurant in restaurants {
                
                guard let lat = restaurant.restaurantLat as? CLLocationDegrees,
                    let long = restaurant.restaurantLong as? CLLocationDegrees
                    else { return }
                
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = restaurant.restaurantName
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                pinArray.append(pointAnnotation)
            }
            
            self.restaurantMapView.addAnnotations(pinArray)
            
            self.restaurantMapView.showAnnotations(pinArray, animated: true)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        search()
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        
        guard let url = URL(string: "https://www.yelp.com") else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}



































