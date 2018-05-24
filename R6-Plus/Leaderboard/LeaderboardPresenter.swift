//
//  LeaderboardPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class LeaderboardPresenter {
    
    private let service: LeaderboardService
    private weak var view: UBTableView?
    private var page = 0
    private var leaderboardRegion: LeaderboardRegion
    
    init(service: LeaderboardService, leaderboardRegion: LeaderboardRegion) {
        self.service = service
        self.leaderboardRegion = leaderboardRegion
    }
    
    private func setupLeaderboard() {
        view?.registerCells([LeaderboardPlayerTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchPlayerList()
    }
    
    private func goToPlayerDetail(_ id: String) {
        let vc = PlayerDetailViewController(playerId: id, playerDetail: nil)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchPlayerList() {
        let input = LeaderboardInput(stat: leaderboardRegion.stat(), limit: 20, page: page)
        service.fetchLeaderboard(input: input) { [weak self] result in
            guard let `self` = self else { return }
            var playerList: [CellComponent] = []
            if case(.success(let players)) = result {
                playerList = self.playersToCellComponents(players)
            }
            self.view?.setCells(playerList, isLoadMore: true)
            self.view?.stopLoading()
            self.view?.reloadTableView()
        }
        page += 20
    }
    
    private func playersToCellComponents(_ players: [Player]) -> [CellComponent] {
        return players.map {
            let data = LeaderboardPlayerCellData(id: $0.id,
                                                 playerImage: $0.imageUrl,
                                                 position: "\($0.placement)",
                                                 nickName: $0.nickname,
                                                 skillPoint: "Skill rating: \($0.skillPoint.twoDecimal())")
            return CellComponent(reuseId: LeaderboardPlayerTableViewCell.reuseId,
                                 data: data) { [weak self] in
                                    self?.goToPlayerDetail(data.id)
            }
        }
    }
}

// MARK: - UBtableViewPresenter
extension LeaderboardPresenter: UBtableViewPresenter {
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupLeaderboard()
    }
    
    func loadMoreInfo() {
        fetchPlayerList()
    }
    
    func refreshControlAction() {
        view?.setCells([], isLoadMore: false)
        view?.reloadTableView()
        page = 0
        fetchPlayerList()
    }
}
