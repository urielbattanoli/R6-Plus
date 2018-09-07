//
//  PlayerDetailService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Alamofire

fileprivate var statistics: String { return "generalpvp_timeplayed,generalpvp_matchplayed,generalpvp_killassists,generalpvp_revive,generalpvp_headshot,generalpvp_penetrationkills,generalpvp_meleekills,generalpvp_matchwon,generalpvp_matchlost,generalpvp_kills,generalpvp_death,generalpvp_bullethit,generalpvp_bulletfired,casualpvp_timeplayed,casualpvp_matchwon,casualpvp_matchlost,casualpvp_matchplayed,casualpvp_kills,casualpvp_death,rankedpvp_matchwon,rankedpvp_matchlost,rankedpvp_timeplayed,rankedpvp_matchplayed,rankedpvp_kills,rankedpvp_death" }

struct PlayerStatisticInput {
    let id: String
    
    var params: [String: Any] {
        return ["populations": id,
                "statistics": statistics]
    }
}

struct PlayerProgressionInput {
    let id: String
    
    var params: [String: Any] {
        return ["profile_ids": id]
    }
}

struct PlayerSeasonInput {
    let id: String
    let season: Int
    let region: String
    
    var params: [String: Any] {
        return ["profile_ids": id,
                "board_id": "pvp_ranked",
                "region_id": region,
                "season_id": season]
    }
}

class PlayerDetailService {
    
    func fetchPlayerStatistics(input: PlayerStatisticInput, completion: @escaping ((Result<NewPlayerDetail>) -> Void)) {
        R6API.playerStatistics(input: input).request { result in
            switch result {
            case .success(let json):
                guard let results = json["results"] as? [String: Any],
                    let elements = results[input.id] as? [String: Any],
                    var detail = try? NewPlayerDetail.fromDictionary(elements) else {
                        completion(.failure(nil))
                        return
                }
                detail.id = input.id
                completion(.success(detail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlayerProgression(input: PlayerProgressionInput, completion: @escaping ((Result<PlayerProgression>) -> Void)) {
        R6API.playerProgression(input: input).request { result in
            switch result {
            case .success(let json):
                guard let results = json["player_profiles"] as? [[String: Any]],
                    let element = results.first,
                    let progression = try? PlayerProgression.fromDictionary(element) else {
                        completion(.failure(nil))
                        return
                }
                completion(.success(progression))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlayerSeason(input: PlayerSeasonInput, completion: @escaping ((Result<PlayerSeason>) -> Void)) {
        R6API.playerSeason(input: input).request { result in
            switch result {
            case .success(let json):
                guard let results = json["players"] as? [String: Any],
                    let element = results[input.id] as? [String: Any],
                    let progression = try? PlayerSeason.fromDictionary(element) else {
                        completion(.failure(nil))
                        return
                }
                completion(.success(progression))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
