//
//  PlayerSeason.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct PlayerSeason: Codable {
    let season: Int
    let region: String
    let wins: Double
    let losses: Double
    let abandons: Int
    let max_mmr: Double
    let mmr: Double
    let rank: Int
    let max_rank: Int
    let skill_mean: Double
    
    var ranking: Ranking {
        return Ranking(rawValue: rank) ?? .unranked
    }
    
    var winRate: Double {
        guard wins + losses != 0 else { return 0 }
        return wins / wins + losses * 100
    }
}
