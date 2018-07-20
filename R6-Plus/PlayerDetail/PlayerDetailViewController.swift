//
//  PlayerDetailViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 04/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PlayerDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var bannerView: GADBannerView!
    @IBOutlet private weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let presenter: PlayerDetailPresenter
    private var sections: [SectionComponent] = []
    private let playerId: String
    private var isFavorite: Bool = false {
        didSet {
            navigationItem.rightBarButtonItem?.image = isFavorite ? #imageLiteral(resourceName: "favorited") : #imageLiteral(resourceName: "unfavorited")
        }
    }
    
    // MARK: - Life cycle
    init(playerId: String, playerDetail: PlayerDetail?) {
        self.playerId = playerId
        presenter = PlayerDetailPresenter(playerDetail: playerDetail, service: PlayerDetailService())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        presenter.fetchPlayerDetailIfNeeded(id: playerId)
        setupTableView()
        addFavoriteButton()
        guard !R6UserDefaults.shared.premiumAccount else { return }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeConstraintHeight),
                                               name: .didBuyPremiumAccount,
                                               object: nil)
        setupBanner()
    }
    
    // MARK: - Functions
    @objc private func changeConstraintHeight() {
        bannerViewHeightConstraint?.constant = 0
    }
    
    private func setupBanner() {
        bannerView.adUnitID = ADS_BANNER_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerViewHeightConstraint.constant = 50
    }
    
    private func addFavoriteButton() {
        let favoriteButton = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "favorited") : #imageLiteral(resourceName: "unfavorited"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteButtonTouched))
        navigationItem.setRightBarButton(favoriteButton, animated: true)
    }
    
    @objc private func favoriteButtonTouched() {
        isFavorite = !isFavorite
        presenter.favoriteTouched()
    }
    
    private func setupTableView() {
        tableView.register(ProfileHeaderTableViewCell.nib, forCellReuseIdentifier: ProfileHeaderTableViewCell.reuseId)
        tableView.register(CollectionTableViewCell.nib, forCellReuseIdentifier: CollectionTableViewCell.reuseId)
        tableView.register(InformationTableViewCell.nib, forCellReuseIdentifier: InformationTableViewCell.reuseId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
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
        (cell as? DynamicCellComponent)?.updateUI(with: component.data as Any)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension PlayerDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = sections[section].header else { return nil }
        let view = HeaderListView()
        view.fillData(header)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 0 else { return 0.1 }
        return 55
    }
}

// MARK: - PlayerDetailView
extension PlayerDetailViewController: PlayerDetailView {
    
    func setPlayerDetail(data: PlayerDetailViewData) {
        title = data.name
        isFavorite = data.isFavorite
        sections = data.sections
        loader.stopAnimating()
        tableView.reloadData()
    }
}
