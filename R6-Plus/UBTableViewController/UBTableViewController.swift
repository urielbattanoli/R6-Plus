//
//  UBTableViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class UBTableViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var bannerView: GADBannerView!
    @IBOutlet private weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var index = 0
    private let presenter: UBTableViewPresenter
    private var sections: [SectionComponent] = []
    private var pagination = 0
    
    // MARK: - Life cycle
    init(presenter: UBTableViewPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        setupTableView()
        guard !R6UserDefaults.shared.premiumAccount else { return }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeConstraintHeight),
                                               name: .didBuyPremiumAccount,
                                               object: nil)
        setupBanner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewdidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
    }
    
    // MARK: - Functions
    @objc private func changeConstraintHeight() {
        bannerViewHeightConstraint?.constant = 0
    }
    
    private func setupBanner() {
        bannerView?.adUnitID = ADS_BANNER_ID
        bannerView?.rootViewController = self
        bannerView?.load(GADRequest())
        bannerViewHeightConstraint?.constant = 50
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    @objc private func refreshControllAction() {
        presenter.refreshControlAction()
    }
}

// MARK: - UITableViewDataSource
extension UBTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = sections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: data.reuseId, for: indexPath)
        if let cellData = data.data {
            (cell as? DynamicCellComponent)?.updateUI(with: cellData)
        }
        if indexPath.row >= pagination - 10 {
            pagination += 20
            presenter.loadMoreInfo()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UBTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = sections[section].header else { return nil }
        let view = HeaderListView()
        view.fillData(header)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[section].header != nil else { return 0.1 }
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].cells[indexPath.row].selectionHandler?()
    }
}

// MARK: - UBTableView
extension UBTableViewController: UBTableView {
    
    func startLoading() {
        loader.startAnimating()
    }
    
    func stopLoading() {
        loader.stopAnimating()
        tableView.refreshControl?.endRefreshing()
    }
    
    func registerCells(_ cells: [NibRegistrableTableViewCell.Type]) {
        cells.forEach { tableView.registerNib(for: $0) }
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setSections(_ sections: [SectionComponent], isLoadMore: Bool) {
        if isLoadMore {
            self.sections += sections
        } else {
            self.sections = sections
        }
    }
    
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshControllAction),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setEmptyMessageIfNeeded(_ message: String) {
        tableView.backgroundView = UIView()
        guard let section = sections.first, section.cells.count == 0 else { return }
        let messageLabel = UILabel(frame: .zero)
        tableView.backgroundView?.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.text = message
    }
    
    func printScreen() -> UIImage {
        return tableView.screenshot()
    }
}
