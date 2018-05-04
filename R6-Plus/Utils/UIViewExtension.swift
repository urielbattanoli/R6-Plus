//
//  UIViewExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

extension UIView {
    
    func setBlackShadow() {
        clipsToBounds = false
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6302642617).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.8
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
