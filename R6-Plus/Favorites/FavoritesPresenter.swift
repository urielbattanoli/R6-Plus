//
//  FavoritesPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class FavoritesPresenter {
    
    private weak var view: UBTableView?
    private var players: [PlayerDetail] = []
    
    private func setupFavorites() {
        view?.registerCells([PlayerTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchFavorites()
        AnalitycsHelper.FavoriteOpened.logEvent()
    }
    
    private func goToPlayerDetail(_ player: PlayerDetail) {
        let vc = PlayerDetailViewController(playerId: player.id, playerDetail: player)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchFavorites() {
        let favorites = R6UserDefaults.shared.favorites
        players = PlayerDetail.fromDictionaryArray(favorites)
        let section = SectionComponent(header: nil,
                                        cells: players.map { self.playerToCellComponent($0) })
        view?.setSections([section], isLoadMore: false)
        view?.stopLoading()
        view?.setEmptyMessageIfNeeded("You don't have any favorites")
        view?.reloadTableView()
    }
    
    private func playerToCellComponent(_ player: PlayerDetail) -> CellComponent {
        let data = PlayerCellData(id: player.id,
                                  imageUrl: player.imageUrl,
                                  name: player.name,
                                  description: "Level: \(player.level)",
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
        view?.setSections([], isLoadMore: false)
        view?.reloadTableView()
        fetchFavorites()
    }
    
    func viewdidAppear() {
        fetchFavorites()
    }
    
    func viewWillDisappear() {}
}
