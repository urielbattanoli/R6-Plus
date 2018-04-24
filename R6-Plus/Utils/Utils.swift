//
//  Utils.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 24/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct Utils {
    
    static func className(for _class: AnyClass) -> String {
        let str = String(describing: type(of: _class))
        guard str.hasSuffix(".Type") else {
            return str
        }
        return String(str[..<str.index(str.endIndex, offsetBy: -5)]) // to remove the ".Type" suffix
    }
}
