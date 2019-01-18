//
//  LeaderboardPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

private typealias strings = Strings.Leaderboard

class LeaderboardPresenter {
    
    private let service: LeaderboardService
    private weak var view: UBTableView?
    private var leaderboardRegion: Region
    
    init(service: LeaderboardService, leaderboardRegion: Region) {
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
        let vc = PlayerDetailViewController(playerId: id, playerDetail: nil, platform: .pc)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchPlayerList() {
        let input = LeaderboardInput(region: leaderboardRegion.toLeaderboard)
        service.fetchLeaderboard(input: input) { [weak self] result in
            guard let `self` = self else { return }
            if case(.success(let players)) = result {
                let playerList = self.playersToCellComponents(players)
                let section = SectionComponent(header: nil, cells: playerList)
                self.view?.setSections([section], isLoadMore: true)
            }
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded(strings.maintenance)
            self.view?.reloadTableView()
        }
    }
    
    private func playersToCellComponents(_ players: [Player]) -> [CellComponent] {
        return players.map {
            let data = LeaderboardPlayerCellData(id: $0.id,
                                                 playerImage: $0.imageUrl,
                                                 position: $0.placement,
                                                 nickName: $0.nickname,
                                                 skillPoint: $0.kd)
            return CellComponent(reuseId: LeaderboardPlayerTableViewCell.reuseId,
                                 data: data) { [weak self] in
                                    self?.goToPlayerDetail(data.id)
            }
        }
    }
}

// MARK: - UBtableViewPresenter
extension LeaderboardPresenter: UBTableViewPresenter {
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupLeaderboard()
    }
    
    func loadMoreInfo() {
        fetchPlayerList()
    }
    
    func refreshControlAction() {
        view?.setSections([], isLoadMore: false)
        view?.reloadTableView()
        fetchPlayerList()
    }
    
    func viewdidAppear() {}
    
    func viewWillDisappear() {}
}
