//
//  LeaderboardPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class LeaderboardPresenter {
    
    private let leaderboardService: LeaderboardService
    weak private var leaderboardView: LeaderboardView?
    
    init(service: LeaderboardService) {
        leaderboardService = service
    }
    
    func attachView(_ view: LeaderboardView) {
        leaderboardView = view
    }
    
    func goToPlayerDetail(id: String) {
        let vc = PlayerDetailViewController(playerId: id)
        (leaderboardView as? UIViewController)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchPlayerList(input: LeaderboardInput) {
        leaderboardService.fetchLeaderboard(input: input) { [weak self] result in
            guard let `self` = self else { return }
            var playerList: [LeaderboardPlayerCellData] = []
            if case(.success(let players)) = result {
                playerList = self.playersToPlayersData(players)
            }
            self.leaderboardView?.setPlayers(players: playerList)
        }
    }
    
    private func playersToPlayersData(_ players: [Player]) -> [LeaderboardPlayerCellData] {
        return players.map { LeaderboardPlayerCellData(id: $0.id,playerImage: $0.imageUrl, position: "\($0.placement)", nickName: $0.nickname, skillPoint: "Skill rating: \($0.skillPoint.twoDecimal())") }
    }
}
