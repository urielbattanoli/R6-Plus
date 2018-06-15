//
//  UIImageViewExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 24/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import Kingfisher
//                        yyyy/MM/dd
private let dateToShow = "2018/06/17"

extension UIImageView {
    
    func loadImage(_ url: String) {        
        guard let date = Utils.defaultDateFormatter.date(from: dateToShow),
            Date() > date else {
                self.backgroundColor = .black
                return
        }
        self.kf.setImage(with: URL(string: url))
    }
}
