//
//  PlayerDetailPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

class PlayerDetailPresenter {
    
    private let playerDetailService: PlayerDetailService
    weak private var playerDetailView: PlayerDetailView?
    
    init(service: PlayerDetailService) {
        playerDetailService = service
    }
    
    func attachView(_ view: PlayerDetailView) {
        playerDetailView = view
    }
    
    func fetchPlayerDetail(id: String) {
        playerDetailService.fetchPlayerDetail(id: id) { [weak self] result in
            guard let `self` = self else { return }
            if case(.success(let playerDetail)) = result {
                self.playerDetailView?.setPlayerDetail(playerDetail: self.playerDetailToData(playerDetail))
            }
        }
    }
    
    private func playerDetailToData(_ playerDetail: PlayerDetail) -> PlayerDetailViewData {
        return PlayerDetailViewData(sections: [generateHeaderData(playerDetail),
                                               generateProfileInfo(playerDetail),
                                               generateTimePlayed(playerDetail),
                                               generateGeneralStats(playerDetail),
                                               generateFightingStats(playerDetail),
                                               generateRankedStats(playerDetail)])
    }
}

// MARK: - Data generation
extension PlayerDetailPresenter {
    
    private func generateHeaderData(_ playerDetail: PlayerDetail) -> PlayerDetailSection {
        let cell = CellComponent(reuseId: ProfileHeaderTableViewCell.reuseId,
                                 data: ProfileHeaderCellData(imageUrl: playerDetail.imageUrl, name: playerDetail.name))
        
        return PlayerDetailSection(title: "", cells: [cell])
    }
    
    private func generateProfileInfo(_ playerDetail: PlayerDetail) -> PlayerDetailSection {
        let infoReuse = InformationTableViewCell.reuseId
        let information =
            [CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Player level", description: "\(playerDetail.level)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "First added", description: "\(playerDetail.level)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Last played", description: "\(playerDetail.level)"))]
        return PlayerDetailSection(title: "Profile Info", cells: information)
    }
    
    private func generateTimePlayed(_ playerDetail: PlayerDetail) -> PlayerDetailSection {
        let stats = playerDetail.stats
        let infoReuse = InformationTableViewCell.reuseId
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Casual", description: stats.casual.timePlayed.inHours())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Ranked", description: stats.ranked.timePlayed.inHours())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Total", description: (stats.casual.timePlayed + stats.ranked.timePlayed).inHours()))]
        return PlayerDetailSection(title: "Time Played", cells: information)
    }
    
    private func generateGeneralStats(_ playerDetail: PlayerDetail) -> PlayerDetailSection {
        let general = playerDetail.stats.general
        let infoReuse = InformationTableViewCell.reuseId
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Wins", description: "\(general.won)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Losses", description: "\(general.lost)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Win rate", description: general.winRate.twoDecimalPercent())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Kills", description: "\(general.kills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Deaths", description: "\(general.deaths)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "K/D ratio", description: general.kdRatio.twoDecimal()))]
        
        return PlayerDetailSection(title: "General Stats", cells: information)
    }
    
    private func generateFightingStats(_ playerDetail: PlayerDetail) -> PlayerDetailSection {
        let general = playerDetail.stats.general
        let infoReuse = InformationTableViewCell.reuseId
        let maxAttackerTime = playerDetail.stats.operatorArray.filter { $0.type == .attacker }.map { $0.timePlayed }.max() ?? 0
        let maxDefenderTime = playerDetail.stats.operatorArray.filter { $0.type == .defender }.map { $0.timePlayed }.max() ?? 0
        let attacker = playerDetail.stats.operatorArray.filter { $0.type == .attacker && $0.timePlayed == maxAttackerTime }.first
        let defender = playerDetail.stats.operatorArray.filter { $0.type == .defender && $0.timePlayed == maxDefenderTime }.first
        
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Kills", description: "\(general.kills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Assists", description: "\(general.assists)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Deaths", description: "\(general.deaths)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Aim(hits)", description: general.aim.twoDecimalPercent())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Percentage of HS", description: "\(general.hsRate.twoDecimalPercent())")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Penetration kills", description: "\(general.penetrationKills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Melee kills", description: "\(general.meleeKills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Revived", description: "\(general.revives)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Favorite attacker", description: attacker?.name ?? "")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Favorite defender", description: defender?.name ?? ""))]
        
        return PlayerDetailSection(title: "Fighting Stats", cells: information)
    }
    
    private func generateRankedStats(_ playerDetail: PlayerDetail) -> PlayerDetailSection {
        let ranked = playerDetail.rank.bestRank
        let infoReuse = InformationTableViewCell.reuseId
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Wins", description: "\(ranked.wins)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Losses", description: "\(ranked.losses)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Abandons", description: "\(ranked.abandons)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Win rate", description: ranked.winRate.twoDecimalPercent())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "MMR", description: ranked.mmr.twoDecimal())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Rank", description: ranked.ranking.name)),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Skill", description: ranked.skill_mean.twoDecimal()))]
        
        return PlayerDetailSection(title: "Ranked Stats", cells: information)
    }
}
