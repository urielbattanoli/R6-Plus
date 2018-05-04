//
//  LeaderboardRegion.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum LeaderboardRegion: String {
    case global = "highest"
    case apac
    case emea
    case ncsa
    
    func stat() -> String {
        return "\(self.rawValue)_skill_adjusted"
    }
    
    func menuName() -> String {
        switch self {
        case .global: return "GLOBAL"
        case .apac: return "ASIA & PACIFIC"
        case .emea: return "EUROPE, AFRICA & MIDDLE EAST"
        case .ncsa: return "NORTH, CENTRAL & SOUTH AMERICA"
        }
    }
}
