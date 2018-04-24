//
//  LeaderboardService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

class LeaderboardService {
    
    func fetchLeaderboard(completion: @escaping ((Result<[Player]>) -> Void)) {
        let params: [String: Any] = ["stat": "highest_skill_adjusted", "limit": 20]
        
        Alamofire.request(Server.leaderboardUrl,
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: Server.headers)
            
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let result = json as? [[String: Any]] else { return }
                    completion(.success(Player.fromDictionaryArray(result)))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
