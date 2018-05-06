//
//  PlayerDetailPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

class PlayerDetailPresenter {
    
    private let playerDetailService: PlayerDetailService
    weak private var playerDetailView: PlayerDetailView?
    
    init(service: PlayerDetailService) {
        playerDetailService = service
    }
    
    func attachView(_ view: PlayerDetailView) {
        playerDetailView = view
    }
    
    func fetchPlayerDetail(id: String) {
        playerDetailService.fetchPlayerDetail(id: id) { [weak self] result in
            guard let `self` = self else { return }
            if case(.success(let playerDetail)) = result {
                self.playerDetailView?.setPlayerDetail(playerDetail: self.playerDetailToData(playerDetail))
            }
        }
    }
    
    private func playerDetailToData(_ playerDetail: PlayerDetail) -> PlayerDetailViewData {
        return PlayerDetailViewData()
    }
}
