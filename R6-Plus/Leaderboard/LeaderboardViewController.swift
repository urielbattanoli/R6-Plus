//
//  LeaderboardViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView?
    
    private let leaderboardPresenter = LeaderboardPresenter(service: LeaderboardService())
    private var playersData: [PlayerViewData] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        leaderboardPresenter.attachView(self)
        leaderboardPresenter.fetchPlayerList()
    }
    
    private func setupTableView() {
        tableView?.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerTableViewCell")
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 100
        tableView?.estimatedSectionHeaderHeight = 100
        tableView?.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension LeaderboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell") as? PlayerTableViewCell
        if playersData.count > indexPath.row {
            cell?.fillData(data: playersData[indexPath.row])
        }
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension LeaderboardViewController: UITableViewDelegate {
    
}

// MARK: - LeaderboardView
extension LeaderboardViewController: LeaderboardView {
    
    func setPlayers(players: [PlayerViewData]) {
        playersData = players
    }
}

