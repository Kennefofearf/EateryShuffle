//
//  RestaurantListTableViewController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/13/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit

class RestaurantListTableViewController: UITableViewController {
    
    static let shared = RestaurantListTableViewController()
    
    var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait)

        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    //newcomment
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RestaurantController.shared.restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RestaurantTableViewCell! = (tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)) as? RestaurantTableViewCell

        cell.restaurant = RestaurantController.shared.restaurants[indexPath.row]

        return cell
    }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                RestaurantController.shared.restaurants.remove(at: indexPath.row)
                tableView.endUpdates()
            }
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let lastSelectedRow = tableView.indexPathForSelectedRow {
            
            tableView.deselectRow(at: lastSelectedRow, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
    }
}
