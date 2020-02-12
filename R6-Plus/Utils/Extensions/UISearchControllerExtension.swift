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
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField,
            let iconView = textField.leftView as? UIImageView {

            textField.defaultTextAttributes = [.foregroundColor: UIColor.white]
            textField.attributedPlaceholder = NSAttributedString(string: "placeholder text",
                                                                 attributes: [.foregroundColor: UIColor.white])
            
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = .white
        }
    }
}
