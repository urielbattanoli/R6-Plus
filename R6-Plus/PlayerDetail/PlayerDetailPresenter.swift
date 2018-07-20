//
//  PlayerDetailPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PlayerDetailPresenter: NSObject {
    
    private let service: PlayerDetailService
    private var playerDetail: PlayerDetail?
    weak private var view: PlayerDetailView?
    
    init(playerDetail: PlayerDetail?, service: PlayerDetailService) {
        self.playerDetail = playerDetail
        self.service = service
    }
    
    func attachView(_ view: PlayerDetailView) {
        self.view = view
    }
    
    func favoriteTouched() {
        guard let playerDetail = playerDetail else { return }
        if playerDetail.isFavorite {
            unsetAsFavorite(player: playerDetail)
        } else {
            setAsFavorite(player: playerDetail)
        }
    }
    
    private func setAsFavorite(player: PlayerDetail) {
        guard let playerDict = try? player.toDictionary() else { return }
        R6UserDefaults.shared.favorites.append(playerDict)
    }
    
    private func unsetAsFavorite(player: PlayerDetail) {
        guard let index = (R6UserDefaults.shared.favorites.index { ($0["id"] as? String ?? "") == player.id }) else { return }
        R6UserDefaults.shared.favorites.remove(at: index)
    }
    
    func fetchPlayerDetailIfNeeded(id: String) {
        if let playerDetail = playerDetail {
            view?.setPlayerDetail(data: playerDetailToData(playerDetail))
            return
        }
        service.fetchPlayerDetail(id: id) { [weak self] result in
            guard let `self` = self else { return }
            if case .success(let playerDetail) = result {
                self.playerDetail = playerDetail
                self.view?.setPlayerDetail(data: self.playerDetailToData(playerDetail))
            }
        }
    }
    
    private func playerDetailToData(_ playerDetail: PlayerDetail) -> PlayerDetailViewData {
        return PlayerDetailViewData(name: playerDetail.name,
                                    isFavorite: playerDetail.isFavorite,
                                    sections: [generateHeaderData(playerDetail),
                                               generateProfileInfo(playerDetail),
                                               generateSeasons(playerDetail),
                                               generateAliases(playerDetail),
                                               generateTimePlayed(playerDetail),
                                               generateGeneralStats(playerDetail),
                                               generateFightingStats(playerDetail),
                                               generateRankedStats(playerDetail),
                                               generateAttackers(playerDetail),
                                               generateDefenders(playerDetail)])
    }
    
    private func openOperatorInfo(_ operatorStats: PlayerDetail.OperatorStats) {
        let sections = [generateOperatorDetail(operatorStats)]
        let vc = OperatorDetailViewController(sections: sections)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        (view as? UIViewController)?.tabBarController?.present(vc, animated: true)
    }
    
    private func openComparison() {
        guard let playerDetail = playerDetail else { return }
        let presenter = OponentComparisonPresenter(service: SearchService(), playerDetail: playerDetail)
        let searchVC = SearchViewController(presenter: presenter)
        searchVC.modalTransitionStyle = .crossDissolve
        let navigation = UINavigationController(rootViewController: searchVC)
        navigation.defaultConfiguration()
        (view as? UIViewController)?.navigationController?.present(navigation, animated: true)
    }
}

// MARK: - Data generation
extension PlayerDetailPresenter {
    
    private func generateHeaderData(_ playerDetail: PlayerDetail) -> SectionComponent {
        let data = ProfileHeaderCellData(imageUrl: playerDetail.imageUrl) { [weak self] in
            self?.openComparison()
        }
        let cell = CellComponent(reuseId: ProfileHeaderTableViewCell.reuseId,
                                 data: data)
        
        return SectionComponent(header: nil, cells: [cell])
    }
    
    private func generateProfileInfo(_ playerDetail: PlayerDetail) -> SectionComponent {
        let infoReuse = InformationTableViewCell.reuseId
        let information =
            [CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Player level", description: "\(playerDetail.level)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "First added", description: playerDetail.created_at.formattedStringDate)),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Last played", description: playerDetail.lastPlayed.last_played?.formattedStringDate ?? "-"))]
        return SectionComponent(header: HeaderListViewData(title: "Profile Info"), cells: information)
    }
    
    private func generateSeasons(_ playerDetail: PlayerDetail) -> SectionComponent {
        let reuseId = SeasonCollectionViewCell.reuseId
        let currentSeason = CellComponent(reuseId: reuseId, data: SeasonCellData(iconImage: playerDetail.rank.bestRank.ranking.image, title: "Season \(playerDetail.rank.season)"))
        var cells: [CellComponent] = [currentSeason]
        playerDetail.seasonRanks.filter { $0.season >= 6 }.reversed().forEach { season in
            cells.append(CellComponent(reuseId: reuseId, data: SeasonCellData(iconImage: season.bestRank.ranking.image, title: "Season \(season.season)")))
        }
        let cellData = CollectionCellData(collectionHeight: 100, cellsToRegister: [SeasonCollectionViewCell.self], items: cells)
        return SectionComponent(header: HeaderListViewData(title: "Seasons"), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateAliases(_ playerDetail: PlayerDetail) -> SectionComponent {
        let reuseId = AliasesCollectionViewCell.reuseId
        var cells: [CellComponent] = []
        for (i, alias) in playerDetail.aliases.enumerated() {
            let hideLine: AliasesCellData.Line
            switch i {
            case 0: hideLine = playerDetail.aliases.count > 1 ? .left : .both
            case playerDetail.aliases.count - 1: hideLine = .right
            default: hideLine = .none
            }
            cells.append(CellComponent(reuseId: reuseId, data: AliasesCellData(title: alias.name, description: alias.created_at.formattedStringDate, hideLine: hideLine)))
        }
        let cellData = CollectionCellData(collectionHeight: 100, cellsToRegister: [AliasesCollectionViewCell.self], items: cells)
        return SectionComponent(header: HeaderListViewData(title: "Aliases"), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateTimePlayed(_ playerDetail: PlayerDetail) -> SectionComponent {
        let stats = playerDetail.stats
        let infoReuse = InformationTableViewCell.reuseId
        let totalTime: String
        if let casualTime = stats.casual.timePlayed,
            let rankedTime = stats.ranked.timePlayed {
            totalTime = (casualTime + rankedTime).inHours()
        } else {
            totalTime = "-"
        }
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Casual", description: stats.casual.timePlayed?.inHours() ?? "-")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Ranked", description: stats.ranked.timePlayed?.inHours() ?? "-")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Total", description: totalTime))]
        return SectionComponent(header: HeaderListViewData(title: "Time Played"), cells: information)
    }
    
    private func generateGeneralStats(_ playerDetail: PlayerDetail) -> SectionComponent {
        let general = playerDetail.stats.general
        let infoReuse = InformationTableViewCell.reuseId
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Wins", description: "\(general.won)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Losses", description: "\(general.lost)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Win rate", description: general.winRate.twoDecimalPercent())),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Kills", description: "\(general.kills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Deaths", description: "\(general.deaths)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "K/D ratio", description: general.kdRatio.twoDecimal()))]
        
        return SectionComponent(header: HeaderListViewData(title: "General Stats"), cells: information)
    }
    
    private func generateFightingStats(_ playerDetail: PlayerDetail) -> SectionComponent {
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
        
        return SectionComponent(header: HeaderListViewData(title: "Fighting Stats"), cells: information)
    }
    
    private func generateRankedStats(_ playerDetail: PlayerDetail) -> SectionComponent {
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
        
        return SectionComponent(header: HeaderListViewData(title: "Ranked Stats"), cells: information)
    }
    
    private func generateAttackers(_ playerDetail: PlayerDetail) -> SectionComponent {
        let reuseId = OperatorCollectionViewCell.reuseId
        let attackers = playerDetail.stats.operatorArray.filter { $0.type == .attacker }
        var cells: [CellComponent] = []
        attackers.forEach { [weak self] op in
            cells.append(CellComponent(reuseId: reuseId, data: OperatorCellData(image: op.image)) {
                self?.openOperatorInfo(op)
            })
        }
        let space = (UIScreen.main.bounds.width - 60 * 4) / 5 + 60
        let height = CGFloat(ceil(Double(attackers.count) / 4)) * space
        let cellData = CollectionCellData(collectionHeight: height, cellsToRegister: [OperatorCollectionViewCell.self], items: cells)
        return SectionComponent(header: HeaderListViewData(title: "Operators (Attackers)"), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateDefenders(_ playerDetail: PlayerDetail) -> SectionComponent {
        let reuseId = OperatorCollectionViewCell.reuseId
        let defenders = playerDetail.stats.operatorArray.filter { $0.type == .defender }
        var cells: [CellComponent] = []
        defenders.forEach { [weak self] op in
            cells.append(CellComponent(reuseId: reuseId, data: OperatorCellData(image: op.image)) {
                self?.openOperatorInfo(op)
            })
        }
        let space = (UIScreen.main.bounds.width - 60 * 4) / 5 + 60
        let height = CGFloat(ceil(Double(defenders.count) / 4)) * space
        let cellData = CollectionCellData(collectionHeight: height, cellsToRegister: [OperatorCollectionViewCell.self], items: cells)
        return SectionComponent(header: HeaderListViewData(title: "Operators (Defenders)"), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateOperatorDetail(_ operatorStats: PlayerDetail.OperatorStats) -> SectionComponent {
        let infoReuse = InformationTableViewCell.reuseId
        let information =
            [CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Kills", description: "\(operatorStats.kills)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Deaths", description: "\(operatorStats.deaths)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Wins", description: "\(operatorStats.won)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Losses", description: "\(operatorStats.lost)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Win rate", description: operatorStats.winRate.twoDecimalPercent())),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Time Played", description: operatorStats.timePlayed.inHours()))]
        return SectionComponent(header: HeaderListViewData(title: operatorStats.name), cells: information)
    }
}
