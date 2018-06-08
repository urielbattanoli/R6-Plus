//
//  ComparisonInfoData.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 08/06/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum BestScore {
    case right
    case left
    case equal
}

struct ComparisonInfoData {
    let leftInfo: String
    let infoName: String
    let rightInfo: String
    let bestScore: BestScore
}
