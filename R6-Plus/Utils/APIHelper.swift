//
//  APIHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 31/08/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

struct UbiToken: Codable {
    let ticket: String
    
    func header() -> [String: String] {
        return ["Ubi-AppId": "39baebad-39e5-4552-8c25-2c9b919064e2",
                "Authorization": "Ubi_v1 t=\(ticket)"]
    }
}

class TokenHelper {
    
    static var token: UbiToken?
    
    private static var timer = Timer()
    @objc static func validUbiToken() {
        Alamofire.request(Server.ubiToken,
                          method: .get,
                          encoding: URLEncoding.default)
            
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let result = json as? [String: Any],
                        let token = try? UbiToken.fromDictionary(result) else {
                        return
                    }
                    self.token = token
                case .failure(_): break
                }
        }
        scheduleTimer()
    }
    
    static func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60 * 60 * 2,
                                     target: self,
                                     selector: #selector(validUbiToken),
                                     userInfo: nil,
                                     repeats: false)
    }
}
