//
//  MenuHeaderMainItem.swift
//  Makadu
//
//  Created by Matheus Alberton on 14/02/18.
//  Copyright © 2018 Makadu. All rights reserved.
//

import UIKit

class MenuHeaderMainItem: NibDesignable {

    @IBOutlet weak var button: UIButton!
    
    var buttonTitle: String? {
        didSet {
            button?.setTitle(buttonTitle, for: .normal)
        }
    }
}
