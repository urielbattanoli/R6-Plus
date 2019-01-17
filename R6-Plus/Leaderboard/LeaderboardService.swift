//
//  LeaderboardService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

struct LeaderboardInput {
    let region: String
    let limit: Int
    let page: Int
    
    var params: [String: Any] {
        return ["region": region,
                "platform": "UPL"]
    }
}

class LeaderboardService {
    
    func fetchLeaderboard(input: LeaderboardInput, completion: @escaping ((Result<[Player]>) -> Void)) {
        R6API.leaderboard(input: input).request { result in
            switch result {
            case .success(let json):
                guard let result = json["result"] as? [[String: Any]] else {
                    completion(.failure(nil))
                    return
                }
                completion(.success(Player.fromDictionaryArray(result)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
