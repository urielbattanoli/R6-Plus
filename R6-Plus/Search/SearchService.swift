//
//  SearchService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 26/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

struct SearchInput {
    let name: String
    let platform: String
    
    var params: [String: Any] {
        return ["nameOnPlatform": name,
                "platformType": platform]
    }
}

class SearchService {
    
    func fetchSearch(input: SearchInput, completion: @escaping ((Result<[SearchedPlayer]>) -> Void)) -> DataRequest {
        return R6API.searchPlayer(input: input).request { result in
                switch result {
                case .success(let json):
                    guard let profiles = json["profiles"] as? [[String: Any]] else {
                        completion(.failure(nil))
                        return
                    }
                    let detail = SearchedPlayer.fromDictionaryArray(profiles)
                    completion(.success(detail))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
