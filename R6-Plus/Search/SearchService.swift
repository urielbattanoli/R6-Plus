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
    
    var headers: [String: String] {
        var deafaultHeaders = Server.headers
        deafaultHeaders["Referer"] = "https://r6db.com/search/\(platform)/\(name)"
        return deafaultHeaders
    }
    
    var params: [String: Any] {
        return ["name": name,
                "platform": platform]
    }
}

class SearchService {
    
    func fetchSearch(input: SearchInput, completion: @escaping ((Result<[SearchedPlayer]>) -> Void)) -> DataRequest {
        return Alamofire.request(Server.searchUrl,
                                 method: .get,
                                 parameters: input.params,
                                 encoding: URLEncoding.default,
                                 headers: input.headers)
            
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let result = json as? [[String: Any]] else {
                        completion(.failure(nil))
                        return
                    }
                    let detail = SearchedPlayer.fromDictionaryArray(result)
                    completion(.success(detail))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
