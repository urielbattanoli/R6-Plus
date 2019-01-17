//
//  Region.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum Region: String {
    case global = "GL"
    case apac = "AS"
    case emea = "EU"
    case ncsa = "NA"
    
    func menuName() -> String {
        switch self {
        case .global: return Strings.Leaderboard.global
        case .apac: return Strings.Leaderboard.apac
        case .emea: return Strings.Leaderboard.emea
        case .ncsa: return Strings.Leaderboard.ncsa
        }
    }
}
