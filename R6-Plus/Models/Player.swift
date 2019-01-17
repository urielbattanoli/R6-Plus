//
//  Player.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct Player: Codable {
    let id: String
    let nickname: String
    let placement: String
    let kd: String
    var imageUrl: String {
        return String(format: Server.baseImageUrl, id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname = "name"
        case placement = "position"
        case kd = "info"
    }
}
