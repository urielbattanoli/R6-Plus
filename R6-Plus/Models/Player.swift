//
//  Player.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

private let baseImageUrl = "https://uplay-avatars.s3.amazonaws.com/%@/default_146_146.png"

class Player: Codable {
    let id: String
    let nickname: String
    let placement: Int
    let skillPoint: Float
    var imageUrl: String {
        return String(format: id, baseImageUrl)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname = "name"
        case placement
        case skillPoint = "value"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        nickname = try container.decode(String.self, forKey: .nickname)
        placement = try container.decode(Int.self, forKey: .placement)
        skillPoint = try container.decode(Float.self, forKey: .skillPoint)
    }
}
