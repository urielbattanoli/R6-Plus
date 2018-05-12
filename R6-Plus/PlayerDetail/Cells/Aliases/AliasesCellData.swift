//
//  AliasesCellData.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 12/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct AliasesCellData {
    let title: String
    let description: String
    let hideLine: Line
    
    enum Line {
        case right
        case left
        case none
    }
}
