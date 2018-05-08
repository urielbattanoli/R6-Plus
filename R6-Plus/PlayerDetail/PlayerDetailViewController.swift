//
//  PlayerDetailViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let presenter = PlayerDetailPresenter(service: PlayerDetailService())
    private var sections: [PlayerDetailSection] = []
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
        
        title = "Detail"
        presenter.attachView(self)
        presenter.fetchPlayerDetail(id: playerId)
        setupTableView()
    }
    
    // MARK: - Functions
    private func setupTableView() {
        tableView.register(ProfileHeaderTableViewCell.nib, forCellReuseIdentifier: ProfileHeaderTableViewCell.reuseId)
        tableView.register(InformationTableViewCell.nib, forCellReuseIdentifier: InformationTableViewCell.reuseId)
        tableView.register(CollectionTableViewCell.nib, forCellReuseIdentifier: CollectionTableViewCell.reuseId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension PlayerDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let component = sections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: component.reuseId)
        
        if let data = component.data as? InformationCellData {
            (cell as? InformationTableViewCell)?.fillData(data)
        } else if let data = component.data as? CollectionCellData {
            (cell as? CollectionTableViewCell)?.fillData(data)
        } else if let data = component.data as? ProfileHeaderCellData {
            (cell as? ProfileHeaderTableViewCell)?.fillData(data)
        }
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension PlayerDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderListView()
        view.fillData(HeaderListViewData(title: sections[section].title))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 0 else { return 0 }
        
        return 55
    }
}

// MARK: - PlayerDetailView
extension PlayerDetailViewController: PlayerDetailView {
    
    func setPlayerDetail(playerDetail: PlayerDetailViewData) {
        sections = playerDetail.sections
        tableView.reloadData()
    }
}
