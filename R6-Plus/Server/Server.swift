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
    
    // MARK: - NEW URLs
    private static var baseR6Url: String { return "http://178.128.75.11:" }
    static var proGamesUrl: String { return "\(baseR6Url)1337/parse/functions/matchesByPage" }
    //    static var proGamesUrl: String { return "\(baseR6Url):1338/parse/functions/matchesByPage" } // TEST
    static var ubiTokenUrl: String { return "\(baseR6Url)5000/token" }
    static var leaderboardUrl: String { return "\(baseR6Url)5000/leaderboard" }
    static var newsUrl: String { return "\(baseR6Url)5000/news" }
    
    private static var baseUbiUrl: String { return "https://public-ubiservices.ubi.com/" }
    static var baseImageUrl: String { return "https://ubisoft-avatars.akamaized.net/%@/default_146_146.png" }
    static var ubiSearchUrl: String { return "\(baseUbiUrl)v2/profiles" }
    
    static func baseUbiV1(platform: Platform) -> String { return "\(baseUbiUrl)v1/spaces/\(platform.id)/sandboxes/\(platform.osbor)/" }
    static func ubiStatisticsUrl(platform: Platform) -> String { return "\(baseUbiV1(platform: platform))playerstats2/statistics" }
    static func ubiProgressionUrl(platform: Platform) -> String { return "\(baseUbiV1(platform: platform))r6playerprofile/playerprofile/progressions" }
    static func ubiSeasonUrl(platform: Platform) -> String { return "\(baseUbiV1(platform: platform))r6karma/players"}
}
