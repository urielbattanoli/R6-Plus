//
//  Match.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct Match: Codable {
    
    let league: String
    let teamB: Team
    let teamA: Team
    let time: String
    let timezone: String
    let result: String
    
    var playDate: Date? {
        let timezone = "UTC\(self.timezone)"
        var a = time.split(separator: " ")
        a.removeLast()
        let time = a.joined(separator: " ")
        return time.toDate(from: "MMMM d, yyyy - HH:mm", timezone: timezone)
    }
    
    struct Team: Codable {
        let name: String
        let image: String
    }
}
