//
//  HeaderListViewData.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct HeaderListViewData {
    let title: String
    let alignment: NSTextAlignment
    
    init(title: String, alignment: NSTextAlignment? = .left) {
        self.title = title
        self.alignment = alignment ?? .left
    }
}
