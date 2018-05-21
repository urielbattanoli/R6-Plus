//
//  FavoritesViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 17/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let presenter = FavoritesPresenter(service: FavoritesService())
    private var playersData: [PlayerCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        presenter.attachView(self)
        presenter.fetchFavorites()
        addRefreshControl()
    }
    
    // MARK: - Functions
    private func setupTableView() {
        tableView.register(PlayerTableViewCell.nib, forCellReuseIdentifier: PlayerTableViewCell.reuseId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    private func setEmptyMessageIfNeeded() {
        tableView.backgroundView = UIView()
        guard playersData.count == 0 else { return }
        let messageLabel = UILabel(frame: .zero)
        tableView.backgroundView?.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.text = "You have not favorites"
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
        presenter.fetchFavorites()
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayerTableViewCell? = tableView.dequeueReusableCell()
        if playersData.count > indexPath.row {
            cell?.fillData(playersData[indexPath.row])
        }
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.goToPlayerDetail(index: indexPath.row)
    }
}

// MARK: - FavoritesView
extension FavoritesViewController: FavoritesView {
    func setPlayers(players: [PlayerCellData]) {
        loader.stopAnimating()
        tableView.refreshControl?.endRefreshing()
        playersData = players
        tableView.reloadData()
        setEmptyMessageIfNeeded()
    }
}
