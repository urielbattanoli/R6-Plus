//
//  LeaderboardViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    // MARK: - Properties
    var index: Int = 0
    
    private let presenter = LeaderboardPresenter(service: LeaderboardService())
    private var playersData: [LeaderboardPlayerCellData] = []
    private var page = 0
    private var leaderboardRegion: LeaderboardRegion
    
    // MARK: - Life cycle
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
        presenter.attachView(self)
        fetchPlayerList()
        addRefreshControl()
    }
    
    // MARK: - Functions
    private func fetchPlayerList() {
        let input = LeaderboardInput(stat: leaderboardRegion.stat(), limit: 20, page: page)
        presenter.fetchPlayerList(input: input)
        page += 20
    }
    
    private func setupTableView() {
        tableView.register(LeaderboardPlayerTableViewCell.nib, forCellReuseIdentifier: LeaderboardPlayerTableViewCell.reuseId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshControllAction),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshControllAction() {
        playersData.removeAll()
        tableView.reloadData()
        page = 0
        fetchPlayerList()
    }
}

// MARK: - UITableViewDataSource
extension LeaderboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeaderboardPlayerTableViewCell? = tableView.dequeueReusableCell()
        if playersData.count > indexPath.row {
            cell?.fillData(playersData[indexPath.row])
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
        presenter.goToPlayerDetail(playersData[indexPath.row].id)
    }
}

// MARK: - LeaderboardView
extension LeaderboardViewController: LeaderboardView {
    
    func setPlayers(players: [LeaderboardPlayerCellData]) {
        loader.stopAnimating()
        tableView.refreshControl?.endRefreshing()
        playersData += players
        tableView.reloadData()
    }
}
