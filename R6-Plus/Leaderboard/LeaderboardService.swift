//
//  LeaderboardService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 14/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

class LeaderboardService {
    
    func fetchLeaderboard(completion: @escaping (([Player]) -> Void)){
        completion([Player(nickname: "Leyru", imageUrl: "", position: 1, skillPoint: 88.8)])
    }
}
