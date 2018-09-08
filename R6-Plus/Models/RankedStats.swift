//
//  RankedStats.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct RankedStats: Codable {
    
    let deaths: Int
    let kills: Int
    let lost: Int
    let played: Int
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
    
    enum CodingKeys: String, CodingKey {
        case kills = "rankedpvp_kills:infinite"
        case won = "rankedpvp_matchwon:infinite"
        case deaths = "rankedpvp_death:infinite"
        case played = "rankedpvp_matchplayed:infinite"
        case timePlayed = "rankedpvp_timeplayed:infinite"
        case lost = "rankedpvp_matchlost:infinite"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kills = try values.decodeIfPresent(Int.self, forKey: .kills) ?? 0
        won = try values.decodeIfPresent(Int.self, forKey: .won) ?? 0
        deaths = try values.decodeIfPresent(Int.self, forKey: .deaths) ?? 0
        played = try values.decodeIfPresent(Int.self, forKey: .played) ?? 0
        timePlayed = try values.decodeIfPresent(Int.self, forKey: .timePlayed) ?? 0
        lost = try values.decodeIfPresent(Int.self, forKey: .lost) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kills, forKey: .kills)
        try container.encode(won, forKey: .won)
        try container.encode(deaths, forKey: .deaths)
        try container.encode(played, forKey: .played)
        try container.encode(timePlayed, forKey: .timePlayed)
        try container.encode(lost, forKey: .lost)
    }
}
