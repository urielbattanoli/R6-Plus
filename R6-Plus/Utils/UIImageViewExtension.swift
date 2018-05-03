//
//  UIImageViewExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 24/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ url: String) {
        self.kf.setImage(with: URL(string: url))
    }
}
