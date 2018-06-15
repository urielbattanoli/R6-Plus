//
//  PlayerComparisonPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 10/06/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

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
//                self.view?.setCells(self.playersToSection(),
//                                    isLoadMore: false)
                self.view?.reloadTableView()
                self.view?.stopLoading()
            }
        }
    }
    
    private func playersToSection() -> [SectionComponent] {
        guard let leftPlayer = leftPlayer,
            let rightPlayer = rightPlayer else { return [] }
        return [generateHeader(leftPlayer: leftPlayer, rightPlayer: rightPlayer)]
    }
    
    private func generateHeader(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
        let data = ComparisonHeaderViewData(leftPlayerImageUrl: leftPlayer.imageUrl,
                                            leftPlayerName: leftPlayer.name,
                                            rightPlayerImageUrl: rightPlayer.imageUrl,
                                            rightPlayerName: rightPlayer.name)
        return SectionComponent(title: "",
                                cells: [CellComponent(reuseId: ComparisonHeaderTableViewCell.reuseId,
                                                      data: data)])
    }
    
//    private func generateGeneralStats(leftPlayer: PlayerDetail, rightPlayer: PlayerDetail) -> SectionComponent {
//        let headerData = HeaderListViewData(title: "General Stats", alignment: .center, color: .lightGray)
//        return SectionComponent(title: <#T##String#>, cells: <#T##[CellComponent]#>)
//    }
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
