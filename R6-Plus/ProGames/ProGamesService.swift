//
//  ProGamesService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

class ProGamesService {
    
    func fetchProGames(completion: @escaping ((Result<[Match]>) -> Void)) {
        R6API.proGames.request { result in
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
