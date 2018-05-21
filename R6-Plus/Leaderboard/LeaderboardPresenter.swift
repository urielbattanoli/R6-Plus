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
    weak private var view: LeaderboardView?
    
    init(service: LeaderboardService) {
        self.service = service
    }
    
    func attachView(_ view: LeaderboardView) {
        self.view = view
    }
    
    func goToPlayerDetail(_ id: String) {
        let vc = PlayerDetailViewController(playerId: id, playerDetail: nil)
        (view as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchPlayerList(input: LeaderboardInput) {
        service.fetchLeaderboard(input: input) { [weak self] result in
            guard let `self` = self else { return }
            var playerList: [LeaderboardPlayerCellData] = []
            if case(.success(let players)) = result {
                playerList = self.playersToPlayersData(players)
            }
            self.view?.setPlayers(players: playerList)
        }
    }
    
    private func playersToPlayersData(_ players: [Player]) -> [LeaderboardPlayerCellData] {
        return players.map { LeaderboardPlayerCellData(id: $0.id,playerImage: $0.imageUrl, position: "\($0.placement)", nickName: $0.nickname, skillPoint: "Skill rating: \($0.skillPoint.twoDecimal())") }
    }
}
