//
//  UINavigationControllerExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 27/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func defaultConfiguration() {
        self.navigationBar.barTintColor = #colorLiteral(red: 0.07450980392, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.isTranslucent = false
    }
}
