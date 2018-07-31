//
//  Match.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct Match: Codable {
    
    let tournament: Tournament
    let team_b: Team
    let team_a: Team
    let start_timestamp: Double
    
    var playDate: Date {
        let myTimeInterval = TimeInterval(start_timestamp / 1000)
        return Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
    }
    
    var isLive: Bool {
        let now = Date().timeIntervalSince1970
        let endGame = start_timestamp + 1 * 60 * 60
        return now > start_timestamp && now < endGame
    }
    
    struct Tournament: Codable {
        let name: String
    }
    
    struct Team: Codable {
        let name: String
        let logo: String
        
        var imageUrl: String {
            return "http://178.128.75.11:1337/public/assets/images/\(logo)"
        }
    }
}