//
//  FavoritesView.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

protocol FavoritesView: class {
    func setPlayers(players: [PlayerCellData])
}
