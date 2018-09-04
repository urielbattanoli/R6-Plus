//
//  UISearchControllerExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 27/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

extension UISearchController {
    
    func defaultConfiguration() {
        self.searchBar.isTranslucent = false
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.tintColor = .white
        let textField = self.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = .white
        if let backgroundview = textField?.subviews.first {
            backgroundview.backgroundColor = .white
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        }
    }
}
