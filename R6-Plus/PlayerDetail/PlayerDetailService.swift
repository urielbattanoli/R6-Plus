//
//  PlayerDetailService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import RxSwift

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

struct PlayerProfileInput {
    let id: String
}

class PlayerDetailService {
    
    func fetchPlayerDetail(id: String) -> Observable<PlayerDetail?> {
        let stats = fetchPlayerStatistics(id: id)
        let prog = fetchPlayerProgression(id: id)
        let season = fetchPlayerSeasons(id: id)
        let profile = fetchPlayerProfile(id: id)
        return Observable.zip([stats, prog, season, profile]) { result in
            let date = Date().nextDay()?.nextDay() ?? Date()
            let dateString = Utils.defaultDateFormatter.string(from: date)
            let name = result[3]["nameOnPlatform"] as? String ?? ""
            let platform = result[3]["platformType"] as? String ?? ""
            let dict: [String: Any] = ["id": id,
                                       "lastUpdated": dateString,
                                       "stats": result[0],
                                       "progression": result[1],
                                       "seasons": [result[2]],
                                       "name": name,
                                       "platform": platform]
            return try? PlayerDetail.fromDictionary(dict)
        }
    }
    
    private func fetchPlayerStatistics(id: String) -> Observable<[String: Any]> {
        let input = PlayerStatisticInput(id: id)
        return Observable.create { observer -> Disposable in
            let request = R6API.playerStatistics(input: input).rxRequest().subscribe(onNext: { result in
                guard let results = result["results"] as? [String: Any],
                    let elements = results[input.id] as? [String: Any] else {
                        observer.onNext([:])
                        return
                }
                var dict: [String: Any] = [:]
                if let casual = try? CasualStats.fromDictionary(elements) {
                    dict["casual"] = try? casual.toDictionary()
                }
                if let ranked = try? RankedStats.fromDictionary(elements) {
                    dict["ranked"] = try? ranked.toDictionary()
                }
                if let general = try? GeneralStats.fromDictionary(elements) {
                    dict["general"] = try? general.toDictionary()
                }
                observer.onNext(dict)
            })
            return Disposables.create { request.dispose() }
        }
    }
    
    private func fetchPlayerProgression(id: String) -> Observable<[String: Any]> {
        let input = PlayerProgressionInput(id: id)
        return Observable.create { oserver -> Disposable in
            let request = R6API.playerProgression(input: input).rxRequest().subscribe(onNext: { result in
                guard let results = result["player_profiles"] as? [[String: Any]],
                    let element = results.first else {
                        oserver.onNext([:])
                        return
                }
                oserver.onNext(element)
            })
            return Disposables.create { request.dispose() }
        }
    }
    
    private func fetchPlayerSeasons(id: String) -> Observable<[String: Any]> {
        let ncsa = PlayerSeasonInput(id: id, season: -1, region: Region.ncsa.rawValue)
        let ncsaRequest = R6API.playerSeason(input: ncsa).rxRequest()
        let apac = PlayerSeasonInput(id: id, season: -1, region: Region.apac.rawValue)
        let apacRequest = R6API.playerSeason(input: apac).rxRequest()
        let emea = PlayerSeasonInput(id: id, season: -1, region: Region.emea.rawValue)
        let emeaRequest = R6API.playerSeason(input: emea).rxRequest()
        return Observable.zip([ncsaRequest,apacRequest, emeaRequest]) { result in
            let goodResult = result.compactMap { (($0["players"] as? [String: Any]) ?? [:])[id] as? [String: Any] }
            guard let season = PlayerSeason.fromDictionaryArray(goodResult)
                .sorted(by: { $0.played > $1.played }).first else { return [:] }
            return goodResult.compactMap { ($0["region"] as? String ?? "") == season.region ? $0 : nil }.first ?? [:]
            
            // FOR REQUEST MORE SEASONS
//            var requests: [Observable<[String: Any]>] = []
//            for i in 1...3 {
//                let input = PlayerSeasonInput(id: id, season: season.season - i, region: season.region)
//                requests.append(R6API.playerSeason(input: input).rxRequest())
//            }
//            return Observable.zip(requests) { seasonsDict -> [PlayerSeason] in
//                let seasons = seasonsDict.compactMap { (($0["players"] as? [String: Any]) ?? [:])[id] as? [String: Any] }
//                return PlayerSeason.fromDictionaryArray(seasons)
//            }
        }
    }
    
    private func fetchPlayerProfile(id: String) -> Observable<[String: Any]> {
        let input = PlayerProfileInput(id: id)
        return Observable.create { oserver -> Disposable in
            let request = R6API.playerProfile(input: input).rxRequest().subscribe(onNext: { result in
                guard let results = result["profiles"] as? [[String: Any]],
                    let element = results.first else {
                        oserver.onNext([:])
                        return
                }
                oserver.onNext(element)
            })
            return Disposables.create { request.dispose() }
        }
    }
}
