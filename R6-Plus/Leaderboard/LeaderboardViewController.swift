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
    @IBOutlet private weak var loader: UIActivityIndicatorView?
    
    private let leaderboardPresenter = LeaderboardPresenter(service: LeaderboardService())
    private var playersData: [PlayerViewData] = []
    
    private var page = 0
    private var leaderboardRegion: LeaderboardRegion
    
    init(leaderboardRegion: LeaderboardRegion) {
        self.leaderboardRegion = leaderboardRegion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        leaderboardPresenter.attachView(self)
        fetchPlayerList()
    }
    
    private func fetchPlayerList() {
        let input = LeaderboardInput(stat: leaderboardRegion.stat(), limit: 20, page: page)
        leaderboardPresenter.fetchPlayerList(input: input)
        page += 20
    }
    
    private func setupTableView() {
        tableView?.register(PlayerTableViewCell.nib, forCellReuseIdentifier: PlayerTableViewCell.reuseId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.reuseId) as? PlayerTableViewCell
        if playersData.count > indexPath.row {
            cell?.fillData(data: playersData[indexPath.row])
        }
        
        if indexPath.row >= page - 10 {
            fetchPlayerList()
        }
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension LeaderboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - LeaderboardView
extension LeaderboardViewController: LeaderboardView {
    
    func setPlayers(players: [PlayerViewData]) {
        loader?.stopAnimating()
        playersData += players
        tableView?.reloadData()
    }
}
