//
//  DoubleExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

extension Double {
    func oneDecimal() -> String {
        return String(format: "%.1f", self)
    }
    
    func twoDecimal() -> String {
        return String(format: "%.2f", self)
    }
    
    func twoDecimalPercent() -> String {
        return "\(self.twoDecimal())%"
    }
    
    func bestScore(rightValue: Double) -> BestScore {
        if self > rightValue {
            return .left
        } else if self < rightValue {
            return .right
        } else {
            return .equal
        }
    }
}
