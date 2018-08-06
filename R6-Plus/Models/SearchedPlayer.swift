//
//  SearchedPlayer.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 27/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct SearchedPlayer: Codable {
    
    let id: String
    let userId: String
    let platform: String
    let name: String
    let level: Int
    let ranks: Ranks
    
    struct Ranks: Codable {
        let apac: Rank
        let emea: Rank
        let ncsa: Rank
        
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
        let mmr: Double
        let rank: Int
        
        var ranking: Ranking {
            return Ranking(rawValue: rank) ?? .unranked
        }
    }
    
    var imageUrl: String {
        guard platform != "XBOX" else {
            return String(format: Server.ubisoftImageUrl, userId)
        }
        return String(format: Server.baseImageUrl, id)
    }
}
