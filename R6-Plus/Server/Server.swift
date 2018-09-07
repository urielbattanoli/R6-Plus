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
    
    private static var baseUbiUrl: String { return "https://public-ubiservices.ubi.com/" }
    static var baseImageUrl: String { return "https://ubisoft-avatars.akamaized.net/%@/default_146_146.png" }
    static var ubiTokenUrl: String { return "\(baseR6Url)5000/token" }
    static var ubiSearchUrl: String { return "\(baseUbiUrl)v2/profiles" }
    
    static var baseUbiV1: String { return "\(baseUbiUrl)v1/spaces/5172a557-50b5-4665-b7db-e3f2e8c5041d/sandboxes/OSBOR_PC_LNCH_A/" }
    static var ubiStatisticsUrl: String { return "\(baseUbiV1)playerstats2/statistics" }
    static var ubiProgressionUrl: String { return "\(baseUbiV1)r6playerprofile/playerprofile/progressions" }
    static var ubiSeasonUrl: String { return "\(baseUbiV1)r6karma/players"}
}
