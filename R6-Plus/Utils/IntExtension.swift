//
//  IntExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

extension Int {
    
    func inHours() -> String {
        return "\((Double(self) / 3600).oneDecimal())h"
    }
    
    func bestScore(rightValue: Int) -> BestScore {
        if self > rightValue {
            return .left
        } else if self < rightValue {
            return .right
        } else {
            return .equal
        }
    }
}
