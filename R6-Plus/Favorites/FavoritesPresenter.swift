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
    private weak var view: UBTableView?
    private var players: [PlayerDetail] = []
    
    init(service: FavoritesService) {
        self.service = service
    }
    
    private func setupFavorites() {
        view?.registerCells([PlayerTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchFavorites()
    }
    
    private func goToPlayerDetail(_ player: PlayerDetail) {
        let vc = PlayerDetailViewController(playerId: player.id, playerDetail: player)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchFavorites() {
        let favorites = R6UserDefaults.shared.favorites
        players = PlayerDetail.fromDictionaryArray(favorites)
        view?.setCells(self.players.map { self.playerToCellComponent($0) }, isLoadMore: false)
        view?.stopLoading()
        view?.setEmptyMessageIfNeeded("You don't have any favorites")
        view?.reloadTableView()
    }
    
    private func playerToCellComponent(_ player: PlayerDetail) -> CellComponent {
        let data = PlayerCellData(id: player.id,
                                  imageUrl: player.imageUrl,
                                  name: player.name,
                                  description: player.rank.bestRank.skill_mean.twoDecimal(),
                                  ranking: player.rank.bestRank.ranking)
        
        return CellComponent(reuseId: PlayerTableViewCell.reuseId,
                             data: data) { [weak self] in
                                self?.goToPlayerDetail(player)
        }
    }
}

// MARK: - UBtableViewPresenter
extension FavoritesPresenter: UBtableViewPresenter {
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupFavorites()
    }
    
    func loadMoreInfo() {
        fetchFavorites()
    }
    
    func refreshControlAction() {
        view?.setCells([], isLoadMore: false)
        view?.reloadTableView()
        fetchFavorites()
    }
    
    func viewdidAppear() {
        fetchFavorites()
    }
}
