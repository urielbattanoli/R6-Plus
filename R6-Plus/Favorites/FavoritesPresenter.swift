//
//  FavoritesPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class FavoritesPresenter {
    
    private let service: FavoritesService
    private weak var view: FavoritesView?
    private var players: [PlayerDetail] = []
    
    init(service: FavoritesService) {
        self.service = service
    }
    
    func attachView(_ view: FavoritesView) {
        self.view = view
    }
    
    func goToPlayerDetail(index: Int) {
        guard index < players.count else { return }
        let vc = PlayerDetailViewController(playerId: players[index].id, playerDetail: players[index])
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchFavorites() {
        let favoritesIds = R6UserDefaults.shared.favoriteIds
        guard favoritesIds.count > 0 else {
            view?.setPlayers(players: [])
            return
        }
        players = []
        var finishedFetchList: [Int] = favoritesIds.map { _ in return 0 }
        favoritesIds.forEach { id in
            service.fetchFavorite(id: id) { [weak self] result in
                finishedFetchList.removeLast()
                guard let `self` = self else { return }
                if case .success(let playerDetail) = result {
                    self.players.append(playerDetail)
                }
                if finishedFetchList.isEmpty {
                    self.view?.setPlayers(players: self.players.map { self.playerToPlayersCellData($0) })
                }
            }
        }
    }
    
    private func playerToPlayersCellData(_ player: PlayerDetail) -> PlayerCellData {
        return PlayerCellData(id: player.id,
                              imageUrl: player.imageUrl,
                              name: player.name,
                              skillPoint: player.rank.bestRank.skill_mean.twoDecimal(),
                              ranking: player.rank.bestRank.ranking)
    }
}
