//
//  Server.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 19/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error?)
}

struct Server {
    
    private static var baseUrl: String { return "https://r6db.com/" }
    
    static var headers: [String: String] { return ["X-App-Id": "app-ios"] }
    static var leaderboardUrl: String { return "\(baseUrl)api/v2/leaderboards" }
    static var playerListUrl: String { return "\(baseUrl)api/v2/players" }
    static func playerByIdUrl(_ id: String) -> String {
        return "\(baseUrl)api/v2/players/\(id)"
    }
}
