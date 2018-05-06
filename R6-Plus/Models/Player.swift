//
//  Player.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

private let baseImageUrl = "https://uplay-avatars.s3.amazonaws.com/%@/default_146_146.png"

struct Player: Codable {
    let id: String
    let nickname: String
    let placement: Int
    let skillPoint: Float
    var imageUrl: String {
        return String(format: baseImageUrl, id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname = "name"
        case placement
        case skillPoint = "value"
    }
}
