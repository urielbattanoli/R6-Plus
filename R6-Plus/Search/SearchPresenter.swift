//
//  SearchPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 26/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

protocol SearchPresenterDelegate: UBtableViewPresenter {
    func searchPlayer(name: String, platform: String)
}

class SearchPresenter {
    
    private let service: SearchService
    private weak var view: UBTableView?
    private var lastInput: SearchInput?
    private var timer: Timer?
    
    init(service: SearchService) {
        self.service = service
    }
    
    private func setupSearch() {
        view?.registerCells([PlayerTableViewCell.self])
        view?.stopLoading()
    }
    
    private func scheduleSearch(input: SearchInput) {
        guard !input.name.isEmpty else {
            view?.setEmptyMessageIfNeeded("")
            return
        }
        lastInput = input
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(fetchSearch),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc private func fetchSearch() {
        view?.startLoading()
        guard let input = lastInput else { return }
        service.fetchSearch(input: input) { [weak self] result in
            guard let `self` = self else { return }
            var playerList: [CellComponent] = []
            if case(.success(let players)) = result {
                playerList = players.map { self.playerToCellComponent($0) }
            }
            self.view?.setCells(playerList, isLoadMore: false)
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded("Player not found")
            self.view?.reloadTableView()
        }
    }
    
    private func playerToCellComponent(_ player: SearchedPlayer) -> CellComponent {
        let data = PlayerCellData(id: player.id,
                                  imageUrl: player.imageUrl,
                                  name: player.name,
                                  description: "Level: \(player.level)",
                                  ranking: player.ranks.bestRank.ranking)
        
        return CellComponent(reuseId: PlayerTableViewCell.reuseId,
                             data: data) { [weak self] in
                                self?.goToPlayerDetail(player)
        }
    }
    
    private func goToPlayerDetail(_ player: SearchedPlayer) {
        let vc = PlayerDetailViewController(playerId: player.id, playerDetail: nil)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UBtableViewPresenter
extension SearchPresenter: SearchPresenterDelegate {
    
    func searchPlayer(name: String, platform: String) {
        scheduleSearch(input: SearchInput(name: name, platform: platform))
    }
    
    func loadMoreInfo() {}
    
    func refreshControlAction() {}
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupSearch()
    }
    
    func viewdidAppear() { }
}
