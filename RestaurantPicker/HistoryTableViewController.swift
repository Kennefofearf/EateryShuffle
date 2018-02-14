//
//  HistoryTableViewController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/24/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    static let shared = HistoryTableViewController()
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait)
        
        formatter.dateFormat = "MM/dd/yy"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RecentlyChosenController.shared.recentlyChosen.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)

        let restaurant = RecentlyChosenController.shared.recentlyChosen[indexPath.row]
        
        guard let oldTime = restaurant.restaurantTimestamp as Date? else { return cell }
        let time = formatter.string(from: oldTime)
        
        cell.textLabel?.text = restaurant.restaurantName
        cell.detailTextLabel?.text = "\(time)"

        return cell
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        CoreDataController.shared.deleteAllCoreData()
        tableView.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
