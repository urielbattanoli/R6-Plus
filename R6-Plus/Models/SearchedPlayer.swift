//
//  SearchedPlayer.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 27/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct SearchedPlayer: Codable {
    
    let profileId: String
    let platformType: String
    let nameOnPlatform: String
    
    var imageUrl: String {
        return String(format: Server.baseImageUrl, profileId)
    }
}
