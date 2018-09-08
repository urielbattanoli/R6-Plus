//
//  GeneralStats.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct GeneralStats: Codable {
    
    let assists: Int
    let bulletsFired: Int
    let bulletsHit: Int
    let deaths: Int
    let headshot: Int
    let kills: Int
    let lost: Int
    let meleeKills: Int
    let penetrationKills: Int
    let played: Int
    let revives: Int
    let timePlayed: Int
    let won: Int
    
    var winRate: Double {
        guard played != 0 else { return 0 }
        return Double(won) / Double(played) * 100
    }
    var kdRatio: Double {
        guard deaths != 0 else { return 0 }
        return Double(kills) / Double(deaths)
    }
    var aim: Double {
        guard bulletsFired != 0 else { return 0 }
        return Double(bulletsHit) / Double(bulletsFired) * 100
    }
    var hsRate: Double {
        guard bulletsHit != 0 else { return 0 }
        return Double(headshot) / Double(bulletsHit) * 100
    }
    
    enum CodingKeys: String, CodingKey {
        case assists = "generalpvp_killassists:infinite"
        case bulletsFired = "generalpvp_bulletfired:infinite"
        case bulletsHit = "generalpvp_bullethit:infinite"
        case deaths = "generalpvp_death:infinite"
        case headshot = "generalpvp_headshot:infinite"
        case kills = "generalpvp_kills:infinite"
        case lost = "generalpvp_matchlost:infinite"
        case meleeKills = "generalpvp_meleekills:infinite"
        case penetrationKills = "generalpvp_penetrationkills:infinite"
        case played = "generalpvp_matchplayed:infinite"
        case revives = "generalpvp_revive:infinite"
        case timePlayed = "generalpvp_timeplayed:infinite"
        case won = "generalpvp_matchwon:infinite"
    }
}
