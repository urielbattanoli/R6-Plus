//
//  ViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 13/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.pushViewController(LeaderboardViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

