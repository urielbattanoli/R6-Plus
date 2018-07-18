//
//  OponentComparisonPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class OponentComparisonPresenter: SearchPresenter {
    
    private let playerDetail: PlayerDetail
    
    init(service: SearchService, playerDetail: PlayerDetail) {
        self.playerDetail = playerDetail
        
        super.init(service: service)
    }
    
    override func searchPlayer(name: String, platform: String) {
        if name.isEmpty {
            showFavoritePlayers()
        } else {
            super.searchPlayer(name: name, platform: platform)
        }
    }
    
    override func initialState() {
        showFavoritePlayers()
    }
    
    private func showFavoritePlayers() {
        let favorites = R6UserDefaults.shared.favorites
        let players = PlayerDetail.fromDictionaryArray(favorites)
        let section = SectionComponent(header: nil,
                                       cells: players.map { self.playerToCellComponent($0.toSearchedPlayer()) })
        view?.setSections([section], isLoadMore: false)
        view?.stopLoading()
        view?.setEmptyMessageIfNeeded("")
        view?.reloadTableView()
    }
    
    override func playerToCellComponent(_ player: SearchedPlayer) -> CellComponent {
        let data = PlayerCellData(id: player.id,
                                  imageUrl: player.imageUrl,
                                  name: player.name,
                                  description: "Level: \(player.level)",
            ranking: player.ranks.bestRank.ranking)
        
        return CellComponent(reuseId: PlayerTableViewCell.reuseId, data: data) { [weak self] in
            guard let `self` = self else { return }
            let comparePresenter = PlayerComparisonPresenter(leftPlayer: self.playerDetail, rightPlayerId: player.id)
            let compareVC = UBTableViewController(presenter: comparePresenter)
            (self.view as? UIViewController)?.navigationController?.pushViewController(compareVC, animated: true)
        }
    }
}

private extension PlayerDetail {
    func toSearchedPlayer() -> SearchedPlayer{
        let apac = SearchedPlayer.Rank(mmr: self.rank.apac.mmr,
                                       rank: self.rank.apac.rank)
        let emea = SearchedPlayer.Rank(mmr: self.rank.emea.mmr,
                                       rank: self.rank.emea.rank)
        let ncsa = SearchedPlayer.Rank(mmr: self.rank.ncsa.mmr,
                                       rank: self.rank.ncsa.rank)
        let ranks = SearchedPlayer.Ranks(apac: apac,
                                         emea: emea,
                                         ncsa: ncsa)
        return SearchedPlayer(id: self.id,
                              name: self.name,
                              level: self.level,
                              ranks: ranks)
    }
}
