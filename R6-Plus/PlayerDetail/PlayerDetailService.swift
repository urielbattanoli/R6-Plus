//
//  PlayerDetailService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

class PlayerDetailService {
    
    func fetchPlayerDetail(id: String, completion: @escaping ((Result<PlayerDetail>) -> Void)) {
        var headers = Server.headers
        headers["Referer"] = "https://r6db.com/player/\(id)"
        
        Alamofire.request(Server.playerByIdUrl(id),
                          method: .get,
                          encoding: URLEncoding.default,
                          headers: headers)
            
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let result = json as? [String: Any],
                        let detail = try? PlayerDetail.fromDictionary(result) else {
                            completion(.failure(nil))
                            return
                    }
                    completion(.success(detail))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
