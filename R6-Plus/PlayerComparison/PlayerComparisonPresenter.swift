//
//  PlayerComparisonPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 10/06/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import RxSwift

private let infoReuseId = ComparisonInfoTableViewCell.reuseId
private typealias strings = Strings.Statistics

class PlayerComparisonPresenter {
    
    private weak var view: UBTableView?
    private var leftPlayer: PlayerDetail?
    private var rightPlayer: PlayerDetail?
    private var rightPlayerId: String?
    private var service = PlayerDetailService()
    private let disposeBag = DisposeBag()
    
    init(leftPlayer: PlayerDetail?, rightPlayerId: String?) {
        self.leftPlayer = leftPlayer
        self.rightPlayerId = rightPlayerId
        AnalitycsHelper.ComparisonDone.logEvent()
    }
    
    private func setupComparison() {
        view?.registerCells([ComparisonHeaderTableViewCell.self,
                             ComparisonInfoTableViewCell.self])
        view?.startLoading()
        guard let rightPlayerId = rightPlayerId else { return }
        fetchPlayerDetailIfNeeded(id: rightPlayerId)
        addShareInfo()
    }
    
    func fetchPlayerDetailIfNeeded(id: String) {
        service.fetchPlayerDetail(id: id).subscribe(onNext: { [weak self] playerDetail in
            guard let `self` = self,
                let playerDetail = playerDetail else { return }
            self.rightPlayer = playerDetail
            self.view?.setSections(self.playersToSection(),
                                   isLoadMore: false)
            self.view?.reloadTableView()
            self.view?.stopLoading()

        }).disposed(by: disposeBag)
    }
    
    private func playersToSection() -> [SectionComponent] {
        guard let leftPlayer = leftPlayer,
            let rightPlayer = rightPlayer else { return [] }
        return [generateHeader(leftPlayer: leftPlayer, rightPlayer: rightPlayer),
                generateGeneralStats(leftPlayer: leftPlayer, rightPlayer: rightPlayer),
                generateTimePlayed(leftPlayer: leftPlayer, rightPlayer: rightPlayer),
                generateFightingStats(leftPlayer: leftPlayer, rightPlayer: rightPlayer),
                generateRankedStats(leftPlayer: leftPlayer, rightPlayer: rightPlayer)]
    }
    
    private func addShareInfo() {
        guard let viewController = view as? UIViewController else { return }
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTouched))
        viewController.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func shareButtonTouched() {
        guard let image = view?.printScreen(),
            let viewController = view as? UIViewController else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        viewController.present(activityViewController, animated: true)
    }
}

// MARK: - UBtableViewPresenter
extension PlayerComparisonPresenter: UBtableViewPresenter {
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupComparison()
    }
    
    func loadMoreInfo() {}
    
    func refreshControlAction() {}
    
    func viewdidAppear() {
        R6UserDefaults.shared.freeComparison = Date().nextDay()
        (UIApplication.shared.delegate as? AppDelegate)?.shouldRotate = true
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func viewWillDisappear() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        (UIApplication.shared.delegate as? AppDelegate)?.shouldRotate = false
    }
}

// MARK: - Data generation
extension PlayerComparisonPresenter {
    
    private func generateHeader(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
        let data = ComparisonHeaderViewData(leftPlayerImageUrl: leftPlayer.imageUrl,
                                            leftPlayerName: leftPlayer.name,
                                            rightPlayerImageUrl: rightPlayer.imageUrl,
                                            rightPlayerName: rightPlayer.name)
        return SectionComponent(header: nil,
                                cells: [CellComponent(reuseId: ComparisonHeaderTableViewCell.reuseId,
                                                      data: data)])
    }
    
    private func generateGeneralStats(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
        let headerData = HeaderListViewData(title: strings.generalStats, alignment: .center)
        guard let left = leftPlayer.stats.general,
            let right = rightPlayer.stats.general else { return SectionComponent(header: nil, cells: []) }
        let cells = [CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(leftPlayer.progression.level)",
                                    infoName: strings.playerLevel,
                                    rightInfo: "\(rightPlayer.progression.level)",
                                    bestScore: leftPlayer.progression.level.bestScore(rightValue: rightPlayer.progression.level))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.won)",
                                    infoName: strings.wins,
                                    rightInfo: "\(right.won)",
                                    bestScore: left.won.bestScore(rightValue: right.won))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.lost)",
                                    infoName: strings.losses,
                                    rightInfo: "\(right.lost)",
                                    bestScore: left.lost.bestScore(rightValue: right.lost))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.winRate.twoDecimalPercent,
                                                            infoName: strings.winRate,
                                                            rightInfo: right.winRate.twoDecimalPercent,
                                                            bestScore: left.winRate.bestScore(rightValue: right.winRate))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.kills)",
                                    infoName: strings.kills,
                                    rightInfo: "\(right.kills)",
                                    bestScore: left.kills.bestScore(rightValue: right.kills))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.deaths)",
                                    infoName: strings.deaths,
                                    rightInfo: "\(right.deaths)",
                                    bestScore: left.deaths.bestScore(rightValue: right.deaths))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.kdRatio.twoDecimal,
                                                            infoName: strings.kdRatio,
                                                            rightInfo: right.kdRatio.twoDecimal,
                                                            bestScore: left.kdRatio.bestScore(rightValue: right.kdRatio)))]
        return SectionComponent(header: headerData, cells: cells)
    }
    
    private func generateTimePlayed(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
        let headerData = HeaderListViewData(title: strings.timePlayed, alignment: .center)
        let left = leftPlayer.stats
        let right = rightPlayer.stats
        
        let totalTimeBS: BestScore
        let leftTotalTime: String
        if let casualTime = left.casual?.timePlayed,
            let rankedTime = left.ranked?.timePlayed {
            leftTotalTime = (casualTime + rankedTime).inHours
        } else {
            leftTotalTime = "-"
        }
        let rightTotalTime: String
        if let casualTime = right.casual?.timePlayed,
            let rankedTime = right.ranked?.timePlayed {
            if leftTotalTime == "-" {
                totalTimeBS = .right
            } else {
                totalTimeBS = (left.casual?.timePlayed ?? 0 + (left.ranked?.timePlayed ?? 0)).bestScore(rightValue: casualTime + rankedTime)
            }
            rightTotalTime = (casualTime + rankedTime).inHours
        } else {
            if leftTotalTime != "-" {
                totalTimeBS = .left
            } else {
                totalTimeBS = .equal
            }
            rightTotalTime = "-"
        }
        let cells = [CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.casual?.timePlayed.inHours ?? "-",
                                                            infoName: strings.casual,
                                                            rightInfo: right.casual?.timePlayed.inHours ?? "-",
                                                            bestScore: (left.casual?.timePlayed ?? 0).bestScore(rightValue: right.casual?.timePlayed ?? 0))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.ranked?.timePlayed.inHours ?? "-",
                                                            infoName: strings.ranked,
                                                            rightInfo: right.ranked?.timePlayed.inHours ?? "-",
                                                            bestScore: (left.ranked?.timePlayed ?? 0).bestScore(rightValue: right.ranked?.timePlayed ?? 0))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: leftTotalTime,
                                                            infoName: strings.total,
                                                            rightInfo: rightTotalTime,
                                                            bestScore: totalTimeBS))]
        return SectionComponent(header: headerData, cells: cells)
    }
    
    private func generateFightingStats(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
        let headerData = HeaderListViewData(title: strings.fightStats, alignment: .center)
        guard let left = leftPlayer.stats.general,
            let right = rightPlayer.stats.general else { return SectionComponent(header: nil, cells: []) }
        
//        let leftAttackerTime = leftPlayer.stats.operatorArray.filter { $0.type == .attacker }.map { $0.timePlayed }.max() ?? 0
//        let leftDefenderTime = leftPlayer.stats.operatorArray.filter { $0.type == .defender }.map { $0.timePlayed }.max() ?? 0
//        let leftAttacker = leftPlayer.stats.operatorArray.filter { $0.type == .attacker && $0.timePlayed == leftAttackerTime }.first
//        let leftDefender = leftPlayer.stats.operatorArray.filter { $0.type == .defender && $0.timePlayed == leftDefenderTime }.first
//
//        let rightAttackerTime = rightPlayer.stats.operatorArray.filter { $0.type == .attacker }.map { $0.timePlayed }.max() ?? 0
//        let rightDefenderTime = rightPlayer.stats.operatorArray.filter { $0.type == .defender }.map { $0.timePlayed }.max() ?? 0
//        let rightAttacker = rightPlayer.stats.operatorArray.filter { $0.type == .attacker && $0.timePlayed == rightAttackerTime }.first
//        let rightDefender = rightPlayer.stats.operatorArray.filter { $0.type == .defender && $0.timePlayed == rightDefenderTime }.first
        
        let cells = [CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.kills)",
                                                            infoName: strings.kills,
                                                            rightInfo: "\(right.kills)",
                                                            bestScore: left.kills.bestScore(rightValue: right.kills))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.assists)",
                                                            infoName: strings.assists,
                                                            rightInfo: "\(right.assists)",
                                                            bestScore: left.assists.bestScore(rightValue: right.assists))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.deaths)",
                                                            infoName: strings.deaths,
                                                            rightInfo: "\(right.deaths)",
                                                            bestScore: left.deaths.bestScore(rightValue: right.deaths))),                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.aim.twoDecimalPercent,
                                                            infoName: strings.aim,
                                                            rightInfo: right.aim.twoDecimalPercent,
                                                            bestScore: left.aim.bestScore(rightValue: right.aim))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.hsRate.twoDecimalPercent,
                                                            infoName: strings.hsPercent,
                                                            rightInfo: right.hsRate.twoDecimalPercent,
                                                            bestScore: left.hsRate.bestScore(rightValue: right.hsRate))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.penetrationKills)",
                                                            infoName: strings.penetration,
                                                            rightInfo: "\(right.penetrationKills)",
                                                            bestScore: left.penetrationKills.bestScore(rightValue: right.penetrationKills))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.meleeKills)",
                                                            infoName: strings.melee,
                                                            rightInfo: "\(right.meleeKills)",
                                                            bestScore: left.meleeKills.bestScore(rightValue: right.meleeKills))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.revives)",
                                                            infoName: strings.revived,
                                                            rightInfo: "\(right.revives)",
                                                            bestScore: left.revives.bestScore(rightValue: right.revives)))]
//                     CellComponent(reuseId: infoReuseId,
//                                   data: ComparisonInfoData(leftInfo: leftAttacker?.name ?? "-",
//                                                            infoName: "Favorite attacker",
//                                                            rightInfo: rightAttacker?.name ?? "-",
//                                                            bestScore: .equal)),
//                     CellComponent(reuseId: infoReuseId,
//                                   data: ComparisonInfoData(leftInfo: leftDefender?.name ?? "-",
//                                                            infoName: "Favorite defender",
//                                                            rightInfo: rightDefender?.name ?? "-",
//                                                            bestScore: .equal))]
        return SectionComponent(header: headerData, cells: cells)
    }
    
    private func generateRankedStats(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
        let headerData = HeaderListViewData(title: strings.rankedStatsLastSeason, alignment: .center)
        guard let left = leftPlayer.seasons.first,
            let right = rightPlayer.seasons.first else { return SectionComponent(header: nil, cells: []) }
        
        let cells = [CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.wins)",
                                                            infoName: strings.wins,
                                                            rightInfo: "\(right.wins)",
                                                            bestScore: left.wins.bestScore(rightValue: right.wins))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.losses)",
                                                            infoName: strings.losses,
                                                            rightInfo: "\(right.losses)",
                                                            bestScore: left.losses.bestScore(rightValue: right.losses))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.abandons)",
                                                            infoName: strings.Abandons,
                                                            rightInfo: "\(right.abandons)",
                                                            bestScore: left.abandons.bestScore(rightValue: right.abandons))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.winRate.twoDecimalPercent,
                                                            infoName: strings.winRate,
                                                            rightInfo: right.winRate.twoDecimalPercent,
                                                            bestScore: left.winRate.bestScore(rightValue: right.winRate))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.mmr.twoDecimal,
                                                            infoName: strings.mmr,
                                                            rightInfo: right.mmr.twoDecimal,
                                                            bestScore: left.mmr.bestScore(rightValue: right.mmr))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.ranking.name,
                                                            infoName: strings.rank,
                                                            rightInfo: right.ranking.name,
                                                            bestScore: left.ranking.rawValue.bestScore(rightValue: right.ranking.rawValue))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.skill_mean.twoDecimal,
                                                            infoName: strings.skill,
                                                            rightInfo: right.skill_mean.twoDecimal,
                                                            bestScore: left.skill_mean.bestScore(rightValue: right.skill_mean)))]
        return SectionComponent(header: headerData, cells: cells)
    }
}
