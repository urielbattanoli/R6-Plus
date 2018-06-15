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
    
    static var headers: [String: String] { return ["X-App-Id": "5e23d930-edd3-4240-b9a9-723c673fb649", "Referer": "https://r6db.com"] }
    static var leaderboardUrl: String { return "\(baseUrl)api/v2/leaderboards" }
    static var searchUrl: String { return "\(baseUrl)api/v2/players" }
    static func playerByIdUrl(_ id: String) -> String {
        return "\(baseUrl)api/v2/players/\(id)"
    }
    static var baseImageUrl: String { return "https://uplay-avatars.s3.amazonaws.com/%@/default_146_146.png" }
}
