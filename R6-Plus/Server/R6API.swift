//
//  R6API.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 06/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum R6API {
    case getToken
    case searchPlayer(input: SearchInput)
    case playerStatistics(input: PlayerStatisticInput)
    case playerProgression(input: PlayerProgressionInput)
    case playerSeason(input: PlayerSeasonInput)
    case proGames(input: ProGamesInput)
    case leaderboard(input: LeaderboardInput)
}

extension R6API {
    
    private var url: String {
        switch self {
        case .getToken: return Server.ubiTokenUrl
        case .searchPlayer: return Server.ubiSearchUrl
        case .playerStatistics(let input): return Server.ubiStatisticsUrl(platform: input.platform)
        case .playerProgression(let input): return Server.ubiProgressionUrl(platform: input.platform)
        case .playerSeason(let input): return Server.ubiSeasonUrl(platform: input.platform)
        case .proGames: return Server.proGamesUrl
        case .leaderboard: return Server.leaderboardUrl
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
        case .playerSeason(let input): return input.params
        case .leaderboard(let input): return input.params
        default: return nil
        }
    }
    
    private var headers: [String: String]? {
        switch self {
        case .proGames, .leaderboard:
            return ["X-Parse-Application-Id": "R6PLUS",
                    "X-Parse-REST-API-Key": "bmoA6075Kxx4SLJ8ZJXXPccILaUrj04U"]
            //            return ["X-Parse-Application-Id": "R6PLUS-DEV",
        //                    "X-Parse-REST-API-Key": "666"]
        default: return TokenHelper.token?.header()
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
        case .proGames: return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
    
    @discardableResult
    func request(completion: @escaping ((Result<[String: Any]>) -> Void)) -> DataRequest {
        return Alamofire.request(url,
                                 method: method,
                                 parameters: params,
                                 encoding: encoding,
                                 headers: headers)
            
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let result = json as? [String: Any] else {
                        guard let result = json as? [[String: Any]] else {
                            completion(.failure(nil))
                            return
                        }
                        completion(.success(["result": result]))
                        return
                    }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func rxRequest() -> Observable<[String: Any]> {
        return Observable.create { observer -> Disposable in
            let request = Alamofire.request(self.url,
                                            method: self.method,
                                            parameters: self.params,
                                            encoding: self.encoding,
                                            headers: self.headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        let result = json as? [String: Any] ?? [:]
                        observer.onNext(result)
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
