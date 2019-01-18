//
//  PlayerDetailPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import RxSwift

private typealias strings = Strings.Statistics

class PlayerDetailPresenter: NSObject {
    
    private let service: PlayerDetailService
    private var playerDetail: PlayerDetail?
    weak private var view: PlayerDetailView?
    private let disposeBag = DisposeBag()
    private let platform: Platform
    
    init(playerDetail: PlayerDetail?, service: PlayerDetailService, platform: Platform) {
        self.platform = platform
        self.playerDetail = playerDetail
        self.service = service
        AnalitycsHelper.DetailOpened.logEvent()
    }
    
    func attachView(_ view: PlayerDetailView) {
        R6UserDefaults.shared.detailOpenedCount += 1
        self.view = view
    }
    
    func favoriteTouched() {
        AnalitycsHelper.FavoritedTouched.logEvent()
        guard let playerDetail = playerDetail else { return }
        if playerDetail.isFavorite {
            unsetAsFavorite(player: playerDetail)
        } else {
            setAsFavorite(player: playerDetail)
        }
    }
    
    private func setAsFavorite(player: PlayerDetail) {
        guard var playerDict = try? player.toDictionary() else { return }
        let date = Date().nextDay()?.nextDay() ?? Date()
        let dateString = Utils.defaultDateFormatter.string(from: date)
        playerDict["lastUpdated"] = dateString
        R6UserDefaults.shared.favorites.insert(playerDict, at: 0)
    }
    
    private func unsetAsFavorite(player: PlayerDetail) {
        guard let index = (R6UserDefaults.shared.favorites.index { ($0["id"] as? String ?? "") == player.id }) else { return }
        R6UserDefaults.shared.favorites.remove(at: index)
    }
    
    func fetchPlayerDetailIfNeeded(id: String) {
        service.fetchPlayerDetail(id: id, platform: platform).subscribe(onNext: { [weak self] result in
            guard let `self` = self, let playerDetail = result else { return }
            if playerDetail.isFavorite {
                self.unsetAsFavorite(player: playerDetail)
                self.setAsFavorite(player: playerDetail)
            }
            self.playerDetail = playerDetail
            self.view?.setPlayerDetail(data: self.playerDetailToData(playerDetail))
        }).disposed(by: disposeBag)
        
        if let playerDetail = playerDetail,
            let date = Utils.defaultDateFormatter.date(from: playerDetail.lastUpdated),
            Date() < date {
            view?.setPlayerDetail(data: playerDetailToData(playerDetail))
            return
        }
    }
    
    private func playerDetailToData(_ playerDetail: PlayerDetail) -> PlayerDetailViewData {
        return PlayerDetailViewData(name: playerDetail.name,
                                    isFavorite: playerDetail.isFavorite,
                                    sections: [generateHeaderData(playerDetail),
                                               generateProfileInfo(playerDetail),
                                               generateSeasons(playerDetail),
//                                               generateAliases(playerDetail),
                                               generateTimePlayed(playerDetail),
                                               generateGeneralStats(playerDetail),
                                               generateFightingStats(playerDetail),
                                               generateRankedStats(playerDetail)])
//                                               generateAttackers(playerDetail),
//                                               generateDefenders(playerDetail)])
        
    }
    
    private func openOperatorInfo(_ operatorStats: OldPlayerDetail.OperatorStats) {
        let sections = [generateOperatorDetail(operatorStats)]
        let vc = OperatorDetailViewController(sections: sections)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        (view as? UIViewController)?.tabBarController?.present(vc, animated: true)
    }
    
    private func openComparison() {
        AnalitycsHelper.DetailComparisonTouched.logEvent()
        guard let playerDetail = playerDetail else { return }
        let presenter = OponentSelectionPresenter(service: SearchService(), playerDetail: playerDetail)
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
            [CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.playerLevel, description: "\(playerDetail.progression.level)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.xp, description: "\(playerDetail.progression.xp)"))]
        return SectionComponent(header: HeaderListViewData(title: strings.profileInfo), cells: information)
    }
    
    private func generateSeasons(_ playerDetail: PlayerDetail) -> SectionComponent {
        let reuseId = SeasonCollectionViewCell.reuseId
        let cells = playerDetail.seasons.map { season in
            CellComponent(reuseId: reuseId, data: SeasonCellData(iconImage: season.ranking.image, title: "\(strings.season) \(season.season)"))
        }
        let cellData = CollectionCellData(collectionHeight: 100, cellsToRegister: [SeasonCollectionViewCell.self], items: cells)
        return SectionComponent(header: HeaderListViewData(title: strings.seasons), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateAliases(_ playerDetail: OldPlayerDetail) -> SectionComponent {
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
        return SectionComponent(header: HeaderListViewData(title: strings.aliases), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateTimePlayed(_ playerDetail: PlayerDetail) -> SectionComponent {
        let stats = playerDetail.stats
        let infoReuse = InformationTableViewCell.reuseId
        let totalTime: String
        if let casualTime = stats.casual?.timePlayed,
            let rankedTime = stats.ranked?.timePlayed {
            totalTime = (casualTime + rankedTime).inHours
        } else {
            totalTime = "-"
        }
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.casual, description: stats.casual?.timePlayed.inHours ?? "-")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.ranked, description: stats.ranked?.timePlayed.inHours ?? "-")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.total, description: totalTime))]
        return SectionComponent(header: HeaderListViewData(title: strings.timePlayed), cells: information)
    }
    
    private func generateGeneralStats(_ playerDetail: PlayerDetail) -> SectionComponent {
        guard let general = playerDetail.stats.general else { return SectionComponent(header: nil, cells: []) }
        let infoReuse = InformationTableViewCell.reuseId
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.wins, description: "\(general.won)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.losses, description: "\(general.lost)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.winRate, description: general.winRate.twoDecimalPercent)),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.kills, description: "\(general.kills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.deaths, description: "\(general.deaths)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.kdRatio, description: general.kdRatio.twoDecimal))]
        
        return SectionComponent(header: HeaderListViewData(title: strings.generalStats), cells: information)
    }
    
    private func generateFightingStats(_ playerDetail: PlayerDetail) -> SectionComponent {
        guard let general = playerDetail.stats.general else { return SectionComponent(header: nil, cells: []) }
        let infoReuse = InformationTableViewCell.reuseId
//        let maxAttackerTime = playerDetail.stats.operatorArray.filter { $0.type == .attacker }.map { $0.timePlayed }.max() ?? 0
//        let maxDefenderTime = playerDetail.stats.operatorArray.filter { $0.type == .defender }.map { $0.timePlayed }.max() ?? 0
//        let attacker = playerDetail.stats.operatorArray.filter { $0.type == .attacker && $0.timePlayed == maxAttackerTime }.first
//        let defender = playerDetail.stats.operatorArray.filter { $0.type == .defender && $0.timePlayed == maxDefenderTime }.first
        
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.kills, description: "\(general.kills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.assists, description: "\(general.assists)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.deaths, description: "\(general.deaths)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.aim, description: general.aim.twoDecimalPercent)),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.hsPercent, description: "\(general.hsRate.twoDecimalPercent)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.penetration, description: "\(general.penetrationKills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.melee, description: "\(general.meleeKills)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.revived, description: "\(general.revives)"))]
//            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Favorite attacker", description: attacker?.name ?? "")),
//            CellComponent(reuseId: infoReuse, data: InformationCellData(title: "Favorite defender", description: defender?.name ?? ""))]
        
        return SectionComponent(header: HeaderListViewData(title: strings.fightStats), cells: information)
    }
    
    private func generateRankedStats(_ playerDetail: PlayerDetail) -> SectionComponent {
        guard let ranked = playerDetail.stats.ranked else { return SectionComponent(header: nil, cells: []) }
        let season = playerDetail.seasons.first
        let infoReuse = InformationTableViewCell.reuseId
        let information = [
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.wins, description: "\(ranked.won)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.losses, description: "\(ranked.lost)")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.winRate, description: ranked.winRate.twoDecimalPercent)),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.mmr, description: season?.mmr.twoDecimal ?? "-")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.rank, description: season?.ranking.name ?? "-")),
            CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.skill, description: season?.skill_mean.twoDecimal ?? "-"))]
        
        return SectionComponent(header: HeaderListViewData(title: strings.rankedStats), cells: information)
    }
    
    private func generateAttackers(_ playerDetail: OldPlayerDetail) -> SectionComponent {
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
        return SectionComponent(header: HeaderListViewData(title: strings.opAttackers), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateDefenders(_ playerDetail: OldPlayerDetail) -> SectionComponent {
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
        return SectionComponent(header: HeaderListViewData(title: strings.opDefenders), cells: [CellComponent(reuseId: CollectionTableViewCell.reuseId, data: cellData)])
    }
    
    private func generateOperatorDetail(_ operatorStats: OldPlayerDetail.OperatorStats) -> SectionComponent {
        let infoReuse = InformationTableViewCell.reuseId
        let information =
            [CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.kills, description: "\(operatorStats.kills)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.deaths, description: "\(operatorStats.deaths)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.wins, description: "\(operatorStats.won)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.losses, description: "\(operatorStats.lost)")),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.winRate, description: operatorStats.winRate.twoDecimalPercent)),
             CellComponent(reuseId: infoReuse, data: InformationCellData(title: strings.timePlayed, description: operatorStats.timePlayed.inHours))]
        return SectionComponent(header: HeaderListViewData(title: operatorStats.name), cells: information)
    }
}
