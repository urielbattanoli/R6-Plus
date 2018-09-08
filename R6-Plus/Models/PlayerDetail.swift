//
//  PlayerDetail.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct PlayerDetail: Codable {
    
    let id: String
    let name: String
    let platform: String
    let lastUpdated: String
    let stats: Stats
    let progression: PlayerProgression
    let seasons: [PlayerSeason]
    
    var isFavorite: Bool {
        return R6UserDefaults.shared.favorites.filter { ($0["id"] as? String ?? "") == id }.count > 0
    }
    
    var imageUrl: String {
        return String(format: Server.baseImageUrl, id)
    }
    
    struct Stats: Codable {
        let casual: CasualStats?
        let ranked: RankedStats?
        let general: GeneralStats?
    }
}
