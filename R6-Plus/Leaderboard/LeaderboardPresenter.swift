//
//  LeaderboardPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

class LeaderboardPresenter {
    
    private let leaderboardService: LeaderboardService
    weak private var leaderboardView: LeaderboardView?
    
    init(service: LeaderboardService) {
        leaderboardService = service
    }
    
    func attachView(_ view: LeaderboardView) {
        leaderboardView = view
    }
    
    func fetchPlayerList() {
        leaderboardService.fetchLeaderboard { [weak self] players in
            guard let `self` = self else { return }
            self.leaderboardView?.setPlayers(players: self.playersToPlayersData(players))
        }
    }
    
    private func playersToPlayersData(_ players: [Player]) -> [PlayerViewData] {
        return players.map { PlayerViewData(playerImage: $0.imageUrl, position: "\($0.position)", nickName: $0.nickname, skillPoint: "\($0.skillPoint)") }
    }
}
