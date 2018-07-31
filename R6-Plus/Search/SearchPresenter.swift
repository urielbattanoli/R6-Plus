//
//  SearchPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 26/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchPresenterDelegate: UBtableViewPresenter {
    func searchPlayer(name: String, platform: String)
}

class SearchPresenter: NSObject {
    
    private let service: SearchService
    weak var view: UBTableView?
    private var lastInput: SearchInput?
    private var timer: Timer?
    private var lastRequest: DataRequest?
    
    init(service: SearchService) {
        self.service = service
        AnalitycsHelper.SearchOpened.logEvent()
    }
    
    func setupSearch() {
        view?.registerCells([PlayerTableViewCell.self])
        view?.stopLoading()
    }
    
    private func scheduleSearch(input: SearchInput) {
        view?.startLoading()
        view?.setSections([], isLoadMore: false)
        view?.reloadTableView()
        view?.setEmptyMessageIfNeeded("")
        lastInput = input
        timer?.invalidate()
        lastRequest?.cancel()
        guard input.name.count > 2 else {
            view?.stopLoading()
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(fetchSearch),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc private func fetchSearch() {
        guard let input = lastInput else { return }
        lastRequest?.cancel()
        lastRequest = service.fetchSearch(input: input) { [weak self] result in
            AnalitycsHelper.SearchDone.logEvent()
            guard let `self` = self else { return }
            var playerList: [CellComponent] = []
            if case(.success(let players)) = result {
                playerList = players.map { self.playerToCellComponent($0) }
            }
            let section = SectionComponent(header: nil, cells: playerList)
            self.view?.setSections([section], isLoadMore: false)
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded("Player not found")
            self.view?.reloadTableView()
        }
    }
    
    func playerToCellComponent(_ player: SearchedPlayer) -> CellComponent {
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
    
    @objc func searchPlayer(name: String, platform: String) {
        scheduleSearch(input: SearchInput(name: name, platform: platform))
    }
    
    func loadMoreInfo() {}
    
    func refreshControlAction() {}
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupSearch()
    }
    
    func viewdidAppear() {}
    func viewWillDisappear() {}
}
