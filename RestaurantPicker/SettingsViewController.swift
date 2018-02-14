//
//  SettingsViewController.swift
//  RestaurantPicker
//
//  Created by Kenny Peterson on 8/22/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mileSliderLabel: UISlider!
    @IBOutlet weak var budgetSlider: UISlider!
    @IBOutlet weak var numberOfMilesLabel: UILabel!
    @IBOutlet weak var budgetSliderLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    static let shared = SettingsViewController()
    
    var searchTerm = "restaurant"
    var radius = 1600
    var budget = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait)

       categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return CategoriesController.shared.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return CategoriesController.shared.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let text = CategoriesController.shared.categories[row]
        
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return attributedText
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let term = CategoriesController.shared.categories[row]
        
        MilesAndRadiusController.shared.searchTerm = term
    }
    
    @IBAction func mileSliderMoved(_ sender: Any) {
        
        numberOfMilesLabel.text = "\(Int(mileSliderLabel.value))"
        
        switch mileSliderLabel.value {
            
        case 1: MilesAndRadiusController.shared.radius = 1600
        case 2: MilesAndRadiusController.shared.radius = 3200
        case 3: MilesAndRadiusController.shared.radius = 4800
        case 4: MilesAndRadiusController.shared.radius = 6400
        case 5: MilesAndRadiusController.shared.radius = 8000
        case 6: MilesAndRadiusController.shared.radius = 9600
        case 7: MilesAndRadiusController.shared.radius = 11200
        case 8: MilesAndRadiusController.shared.radius = 12800
        case 9: MilesAndRadiusController.shared.radius = 14400
        case 10: MilesAndRadiusController.shared.radius = 16000
        default: break
        }
    }
    
    @IBAction func budgetSliderMoved(_ sender: Any) {
        
        budgetSliderLabel.text = "$"
        
        switch (Int(budgetSlider.value)) {
            
        case 1: budgetSliderLabel.text = "$"
            MilesAndRadiusController.shared.budget = 1
        case 2: budgetSliderLabel.text = "$$"
            MilesAndRadiusController.shared.budget = 2
        case 3: budgetSliderLabel.text = "$$$"
            MilesAndRadiusController.shared.budget = 3
        case 4: budgetSliderLabel.text = "$$$$"
            MilesAndRadiusController.shared.budget = 4
        default: break
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        MilesAndRadiusController.shared.radius = 1600
        MilesAndRadiusController.shared.searchTerm = "restaurant"
        MilesAndRadiusController.shared.budget = 1
        
        dismiss(animated: true, completion: nil)
    }
}
