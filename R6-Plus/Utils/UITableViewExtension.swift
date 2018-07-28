//
//  UITableViewExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 27/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

extension UITableView {
    func screenshot() -> UIImage {
        let savedContentOffset = self.contentOffset
        let numberOfSections = self.numberOfSections
        var height: CGFloat = 0
        for section in 0..<numberOfSections {
            height += section == 0 ? 212 : CGFloat(self.numberOfRows(inSection: section)) * 26.33 + 79
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.contentSize.width, height: height), false, UIScreen.main.scale)
        self.contentOffset = CGPoint(x: 0, y: 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        for section in 0..<numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                self.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: false)
                self.layer.render(in: UIGraphicsGetCurrentContext()!)
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        self.contentOffset = savedContentOffset
        UIGraphicsEndImageContext()
        return image
    }
}
