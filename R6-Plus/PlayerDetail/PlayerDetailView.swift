//
//  PlayerDetailView.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

protocol PlayerDetailView: class {
    func setPlayerDetail(playerDetail: PlayerDetailViewData)
}

struct PlayerDetailViewData {
    let sections: [PlayerDetailSection]
}

struct PlayerDetailSection {
    let title: String
    let cells: [CellComponent]
}