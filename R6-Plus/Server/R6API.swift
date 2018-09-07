//
//  R6API.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

enum R6API {
    case getToken
    case searchPlayer(input: SearchInput)
    case playerStatistics(input: PlayerStatisticInput)
    case playerProgression(input: PlayerProgressionInput)
    case playerSeason(input: PlayerSeasonInput)
    case proGames(input: ProGamesInput)
}

extension R6API {
    
    private var url: String {
        switch self {
        case .getToken: return Server.ubiTokenUrl
        case .searchPlayer: return Server.ubiSearchUrl
        case .playerStatistics: return Server.ubiStatisticsUrl
        case .playerProgression: return Server.ubiProgressionUrl
        case .playerSeason: return Server.ubiSeasonUrl
        case .proGames: return Server.proGamesUrl
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .proGames: return .post
        default: return .get
        }
    }
    
    private var params: [String: Any]? {
        switch self {
        case .searchPlayer(let input): return input.params
        case .proGames(let input): return input.params
        case .playerStatistics(let input): return input.params
        case .playerProgression(let input): return input.params
        default: return nil
        }
    }
    
    private var headers: [String: String]? {
        switch self {
        case .proGames:
            return ["X-Parse-Application-Id": "R6PLUS",
                    "X-Parse-REST-API-Key": "bmoA6075Kxx4SLJ8ZJXXPccILaUrj04U"]
//            return ["X-Parse-Application-Id": "R6PLUS-DEV",
//                    "X-Parse-REST-API-Key": "666"]
        default: return TokenHelper.token?.header()
        }
    }
    
    @discardableResult
    func request(completion: @escaping ((Result<[String: Any]>) -> Void)) -> DataRequest {
        return Alamofire.request(url,
                                 method: method,
                                 parameters: params,
                                 encoding: URLEncoding.default,
                                 headers: headers)
            
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let result = json as? [String: Any] else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
