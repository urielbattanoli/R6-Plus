//
//  LeaderboardView.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

protocol LeaderboardView: class {
    func setPlayers(players: [LeaderboardPlayerCellData])
}
