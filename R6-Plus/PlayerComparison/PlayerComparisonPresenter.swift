//
//  PlayerComparisonPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 10/06/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

private let infoReuseId = ComparisonInfoTableViewCell.reuseId

class PlayerComparisonPresenter {
    
    private weak var view: UBTableView?
    private var leftPlayer: PlayerDetail?
    private var rightPlayer: PlayerDetail?
    private var rightPlayerId: String?
    private var service = PlayerDetailService()
    
    init(leftPlayer: PlayerDetail?, rightPlayerId: String?) {
        self.leftPlayer = leftPlayer
        self.rightPlayerId = rightPlayerId
    }
    
    private func setupComparison() {
        view?.registerCells([ComparisonHeaderTableViewCell.self,
                             ComparisonInfoTableViewCell.self])
        view?.startLoading()
        guard let rightPlayerId = rightPlayerId else { return }
        fetchPlayerDetailIfNeeded(id: rightPlayerId)
    }
    
    func fetchPlayerDetailIfNeeded(id: String) {
        service.fetchPlayerDetail(id: id) { [weak self] result in
            guard let `self` = self else { return }
            if case .success(let playerDetail) = result {
                self.rightPlayer = playerDetail
                self.view?.setSections(self.playersToSection(),
                                    isLoadMore: false)
                self.view?.reloadTableView()
                self.view?.stopLoading()
            }
        }
    }
    
    private func playersToSection() -> [SectionComponent] {
        guard let leftPlayer = leftPlayer,
            let rightPlayer = rightPlayer else { return [] }
        return [generateHeader(leftPlayer: leftPlayer, rightPlayer: rightPlayer),
                generateGeneralStats(leftPlayer: leftPlayer, rightPlayer: rightPlayer)]
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
        let headerData = HeaderListViewData(title: "General Stats", alignment: .center)
        let left = leftPlayer.stats.general
        let right = rightPlayer.stats.general
        let cells = [CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(leftPlayer.level)",
                                                            infoName: "Player level",
                                                            rightInfo: "\(rightPlayer.level)",
                                    bestScore: leftPlayer.level.bestScore(rightValue: rightPlayer.level))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.won)",
                                                            infoName: "Wins",
                                                            rightInfo: "\(right.won)",
                                                            bestScore: left.won.bestScore(rightValue: right.won))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.lost)",
                                                            infoName: "Losses",
                                                            rightInfo: "\(right.lost)",
                                                            bestScore: left.lost.bestScore(rightValue: right.lost))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.winRate.twoDecimalPercent(),
                                                            infoName: "Win rate",
                                                            rightInfo: right.winRate.twoDecimalPercent(),
                                                            bestScore: left.winRate.bestScore(rightValue: right.winRate))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.kills)",
                                                            infoName: "Kills",
                                                            rightInfo: "\(right.kills)",
                                                            bestScore: left.kills.bestScore(rightValue: right.kills))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: "\(left.deaths)",
                                                            infoName: "Deaths",
                                                            rightInfo: "\(right.deaths)",
                                                            bestScore: left.deaths.bestScore(rightValue: right.deaths))),
                     CellComponent(reuseId: infoReuseId,
                                   data: ComparisonInfoData(leftInfo: left.kdRatio.twoDecimal(),
                                                            infoName: "K/D ratio",
                                                            rightInfo: right.kdRatio.twoDecimal(),
                                                            bestScore: left.kdRatio.bestScore(rightValue: right.kdRatio)))]
        return SectionComponent(header: headerData, cells: cells)
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
    
    func viewdidAppear() {}
}
