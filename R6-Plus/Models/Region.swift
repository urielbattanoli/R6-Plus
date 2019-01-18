//
//  Region.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum Region: String {
    case global
    case apac
    case emea
    case ncsa
    
    var toLeaderboard: String {
        switch self {
        case .global: return "GL"
        case .apac: return "AS"
        case .emea: return "EU"
        case .ncsa: return "NA"
        }
    }
    
    var menuName: String {
        switch self {
        case .global: return Strings.Leaderboard.global
        case .apac: return Strings.Leaderboard.apac
        case .emea: return Strings.Leaderboard.emea
        case .ncsa: return Strings.Leaderboard.ncsa
        }
    }
}
