//
//  PlayerDetail.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct PlayerDetail: Codable {
    
    let id: String
    let userId: String
    let name: String
    let level: Int
    let aliases: [Aliases]
    let lastPlayed: LastPlayed
    let rank: SeasonRank
    let seasonRanks: [SeasonRank]
    let stats: Stats
    
    struct Aliases: Codable {
        let name: String
        let created_at: String
    }
    
    struct LastPlayed: Codable {
        let casual: Int
        let ranked: Int
        let last_played: String
    }
    
    struct SeasonRank: Codable {
        let apac: Rank
        let emea: Rank
        let ncsa: Rank
        let season: Int
    }
    
    struct Rank: Codable {
        let region: String
        let wins: Int
        let losses: Int
        let abandons: Int
        let max_mmr: Float
        let mmr: Float
        let rank: Int
        let max_rank: Int
        let skill_mean: Float
        let skill_stdev: Float
    }
    
    struct Stats: Codable {
        let casual: GameStats
        let ranked: GameStats
        let general: GeneralStats
        let operators: Operators
        
        enum CodingKeys: String, CodingKey {
            case casual
            case ranked
            case general
            case operators = "operator"
        }
    }
    
    struct GameStats: Codable {
        let deaths: Int
        let kills: Int
        let lost: Int
        let played: Int
        let timePlayed: Int
        let won: Int
    }
    
    struct GeneralStats: Codable {
        let assists: Int
        let blindKills: Int
        let bulletsFired: Int
        let bulletsHit: Int
        let dbno: Int
        let dbnoAssists: Int
        let deaths: Int
        let gadgetsDestroyed: Int
        let headshot: Int
        let hostageDefense: Int
        let hostageRescue: Int
        let kills: Int
        let lost: Int
        let meleeKills: Int
        let penetrationKills: Int
        let played: Int
        let rappelBreaches: Int
        let revives: Int
        let revivesDenied: Int
        let serverAggression: Int
        let serverDefender: Int
        let serversHacked: Int
        let suicides: Int
        let timePlayed: Int
        let won: Int
    }
    
    struct Operators: Codable {
        let ash: OperatorStats
        let bandit: OperatorStats
        let blackbeard: OperatorStats
        let blitz: OperatorStats
        let buck: OperatorStats
        let castle: OperatorStats
        let capitao: OperatorStats
        let caveira: OperatorStats
        let doc: OperatorStats
        let dokkaebi: OperatorStats
        let echo: OperatorStats
        let ela: OperatorStats
        let finka: OperatorStats
        let frost: OperatorStats
        let fuze: OperatorStats
        let glaz: OperatorStats
        let hibana: OperatorStats
        let iq: OperatorStats
        let jackal: OperatorStats
        let jager: OperatorStats
        let kapkan: OperatorStats
        let lesion: OperatorStats
        let lion: OperatorStats
        let mira: OperatorStats
        let montagne: OperatorStats
        let mute: OperatorStats
        let pulse: OperatorStats
        let rook: OperatorStats
        let sledge: OperatorStats
        let smoke: OperatorStats
        let tachanka: OperatorStats
        let thatcher: OperatorStats
        let thermite: OperatorStats
        let twitch: OperatorStats
        let valkyrie: OperatorStats
        let vigil: OperatorStats
        let ying: OperatorStats
        let zofia: OperatorStats
    }
    
    struct OperatorStats: Codable {
        let won: Int
        let lost: Int
        let kills: Int
        let deaths: Int
        let timePlayed: Int
        let name: String
    }
}
