//
//  PlayerDetailViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    // MARK: - Properties
    private let presenter = PlayerDetailPresenter(service: PlayerDetailService())
    private let playerId: String
    
    // MARK: - Life cycle
    init(playerId: String) {
        self.playerId = playerId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        presenter.fetchPlayerDetail(id: playerId)
    }
    
    // MARK: - Functions
}

// MARK: - PlayerDetailView
extension PlayerDetailViewController: PlayerDetailView {
    
    func setPlayerDetail(playerDetail: PlayerDetailViewData) {
        
    }
}
