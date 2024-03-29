//
//  OldPlayerDetail.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct OldPlayerDetail: Codable {
    
    let id: String
    let userId: String
    let platform: String
    let name: String
    let level: Int
    let aliases: [Alias]
    let lastPlayed: LastPlayed
    let rank: SeasonRank
    let seasonRanks: [SeasonRank]
    let stats: Stats
    let created_at: String
    let lastUpdated: String?
    
    var isFavorite: Bool {
        return R6UserDefaults.shared.favorites.filter { ($0["id"] as? String ?? "") == id }.count > 0
    }
    
    var imageUrl: String {
        return String(format: Server.baseImageUrl, id)
    }
    
    struct Alias: Codable {
        let name: String
        let created_at: String
    }
    
    struct LastPlayed: Codable {
        let casual: Int
        let ranked: Int
        let last_played: String?
    }
    
    struct SeasonRank: Codable {
        let apac: Rank
        let emea: Rank
        let ncsa: Rank
        let season: Int
        
        var bestRank: Rank {
            let bestRank = [apac.rank, emea.rank, ncsa.rank].max() ?? 0
            switch bestRank {
            case apac.rank: return apac
            case emea.rank: return emea
            default: return ncsa
            }
        }
    }
    
    struct Rank: Codable {
        let region: String
        let wins: Int
        let losses: Int
        let abandons: Int
        let max_mmr: Double
        let mmr: Double
        let rank: Int
        let max_rank: Int
        let skill_mean: Double
        let skill_stdev: Double
        
        var ranking: Ranking {
            return Ranking(rawValue: rank) ?? .unranked
        }
        
        var winRate: Double {
            guard wins + losses != 0 else { return 0 }
            return Double(wins) / Double(wins + losses) * 100
        }
    }
    
    struct Stats: Codable {
        let casual: GameStats
        let ranked: GameStats
        let general: GeneralStats
        let operators: Operators
        
        var operatorArray: [OperatorStats] {
            return [operators.ash,
                    operators.bandit,
                    operators.blackbeard,
                    operators.blitz,
                    operators.buck,
                    operators.capitao,
                    operators.castle,
                    operators.caveira,
                    operators.doc,
                    operators.dokkaebi,
                    operators.echo,
                    operators.ela,
                    operators.finka,
                    operators.frost,
                    operators.fuze,
                    operators.glaz,
                    operators.hibana,
                    operators.iq,
                    operators.jackal,
                    operators.jager,
                    operators.kapkan,
                    operators.lesion,
                    operators.lion,
                    operators.mira,
                    operators.montagne,
                    operators.mute,
                    operators.pulse,
                    operators.rook,
                    operators.sledge,
                    operators.smoke,
                    operators.tachanka,
                    operators.thatcher,
                    operators.thermite,
                    operators.twitch,
                    operators.valkyrie,
                    operators.vigil,
                    operators.ying,
                    operators.zofia]
        }
        
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
        let timePlayed: Int?
        let won: Int
    }
    
    struct GeneralStats: Codable {
        let assists: Int
        let bulletsFired: Double
        let bulletsHit: Double
        let deaths: Double
        let headshot: Double
        let kills: Double
        let lost: Double
        let meleeKills: Int
        let penetrationKills: Int
        let played: Double
        let revives: Int
        let timePlayed: Int
        let won: Double
        
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
        
        var winRate: Double {
            guard won + lost != 0 else { return 0 }
            return Double(won) / Double(won + lost) * 100
        }
        
        var image: UIImage {
            return Operator(rawValue: name)?.image ?? UIImage()
        }
        
        var type: OperatorType {
            return Operator(rawValue: name)?.type ?? .unknown
        }
    }
}
