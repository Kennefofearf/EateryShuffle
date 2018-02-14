//
//  HelpViewController.swift
//  EateryShuffle
//
//  Created by Kenny Peterson on 8/28/17.
//  Copyright © 2017 Kenny Peterson. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
