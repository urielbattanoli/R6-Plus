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
        AnalitycsHelper.FavoriteOpened.logEvent()
        view?.registerCells([PlayerTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchFavorites()
        addSearchButton()
    }
    
    private func goToPlayerDetail(_ player: PlayerDetail) {
        let platform = Platform(rawValue: player.platform) ?? .pc
        let vc = PlayerDetailViewController(playerId: player.id, playerName: player.name, playerDetail: player, platform: platform)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchFavorites() {
        let favorites = R6UserDefaults.shared.favorites
        players = PlayerDetail.fromDictionaryArray(favorites)
        let cells = players.map { self.playerToCellComponent($0) }
        let section = SectionComponent(header: nil,
                                        cells: cells)
        if cells.count > 0 {
            view?.setSections([section], isLoadMore: false)
        }
        view?.stopLoading()
        view?.setEmptyMessageIfNeeded(Strings.Favorites.noFavorites)
        view?.reloadTableView()
    }
    
    private func playerToCellComponent(_ player: PlayerDetail) -> CellComponent {
        let data = PlayerCellData(imageUrl: player.imageUrl,
                                  name: player.name,
                                  description: player.platform)
        
        return CellComponent(reuseId: PlayerTableViewCell.reuseId,
                             data: data) { [weak self] in
                                self?.goToPlayerDetail(player)
        }
    }
    
    private func addSearchButton() {
        guard let viewController = view as? UIViewController else { return }
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched))
        viewController.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func searchButtonTouched() {
        let presenter = SearchPresenter(service: SearchService())
        SearchRouter.openSearch(viewController: view as? UIViewController, presenter: presenter)
    }
}

// MARK: - UBtableViewPresenter
extension FavoritesPresenter: UBTableViewPresenter {
    
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
