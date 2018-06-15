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
    let name: String
    let isFavorite: Bool
    let sections: [SectionComponent]
}
