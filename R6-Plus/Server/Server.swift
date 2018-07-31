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
    
    static var headers: [String: String] { return ["X-App-Id": "b0815d12-ce26-462f-85ec-b866f24db0f0",
                                                   "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36"] }
    static var leaderboardUrl: String { return "\(baseUrl)api/v2/leaderboards" }
    static var searchUrl: String { return "\(baseUrl)api/v2/players" }
    static func playerByIdUrl(_ id: String) -> String {
        return "\(baseUrl)api/v2/players/\(id)"
    }
    static var baseImageUrl: String { return "https://uplay-avatars.s3.amazonaws.com/%@/default_146_146.png" }
    static var proGamesUrl: String { return "http://178.128.75.11:1337/parse/functions/matches" }
//    static var proGamesUrl: String { return "http://178.128.75.11:1338/parse/functions/matchesByPage" }
}
