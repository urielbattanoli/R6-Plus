//
//  ProGamesService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

class ProGamesService {
    
    func fetchProGames(page: Int, limit: Int, completion: @escaping ((Result<[Match]>) -> Void)) {
        let headers: [String: String] = ["X-Parse-Application-Id": "R6PLUS",
                                         "X-Parse-REST-API-Key": "bmoA6075Kxx4SLJ8ZJXXPccILaUrj04U"]
//        let headers: [String: String] = ["X-Parse-Application-Id": "R6PLUS-DEV",
//                                         "X-Parse-REST-API-Key": "666"]
        
        let params: [String: Any] = ["limit": limit, "page": page]
        Alamofire.request(Server.proGamesUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let json = json as? [String: Any],
                        let result = json["result"] as? [[String: Any]] else {
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
