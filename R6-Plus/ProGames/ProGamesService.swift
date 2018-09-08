//
//  ProGamesService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct ProGamesInput {
    let limit: Int
    let page: Int
    
    var params: [String: Any] {
        return ["limit": limit,
                "page": page]
    }
}

class ProGamesService {
    
    func fetchProGames(input: ProGamesInput, completion: @escaping ((Result<[Match]>) -> Void)) {
        R6API.proGames(input: input).request { result in
                switch result {
                case .success(let json):
                    guard let result = json["result"] as? [[String: Any]] else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(Match.fromDictionaryArray(result)))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
