//
//  Ranking.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum Ranking: Int {
    
    case copper4 = 0
    case copper3 = 1
    case copper2 = 2
    case copper1 = 3
    case bronze4 = 4
    case bronze3 = 5
    case bronze2 = 6
    case bronze1 = 7
    case silver4 = 8
    case silver3 = 9
    case silver2 = 10
    case silver1 = 11
    case gold4 = 12
    case gold3 = 13
    case gold2 = 14
    case gold1 = 15
    case platinum4 = 16
    case platinum3 = 17
    case platinum2 = 18
    case platinum1 = 19
    case diamond = 20
    case unranked
    
    var name: String {
        switch self {
        case .copper4: return "Copper IV"
        case .copper3: return "Copper III"
        case .copper2: return "Copper II"
        case .copper1: return "Copper I"
        case .bronze4: return "Bronze IV"
        case .bronze3: return "Bronze III"
        case .bronze2: return "Bronze II"
        case .bronze1: return "Bronze I"
        case .silver4: return "Silver IV"
        case .silver3: return "Silver III"
        case .silver2: return "Silver II"
        case .silver1: return "Silver I"
        case .gold4: return "Gold IV"
        case .gold3: return "Gold III"
        case .gold2: return "Gold II"
        case .gold1: return "Gold I"
        case .platinum4: return "Platinum IV"
        case .platinum3: return "Platinum III"
        case .platinum2: return "Platinum II"
        case .platinum1: return "Platinum I"
        case .diamond: return "Diamond"
        case .unranked: return "Unranked"
        }
    }
}
