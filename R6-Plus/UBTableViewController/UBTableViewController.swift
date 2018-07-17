//
//  UBTableViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 15/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class UBTableViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    // MARK: - Properties
    var index = 0
    private var presenter: UBtableViewPresenter
    private var sections: [SectionComponent] = []
    private var pagination = 0
    
    // MARK: - Life cycle
    init(presenter: UBtableViewPresenter) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewdidAppear()
    }
    
    // MARK: - Functions
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
        let view = HeaderListView()
        view.fillData(HeaderListViewData(title: sections[section].title ?? "",
                                         alignment: .left,
                                         color: .white))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[section].title != nil else { return 0.1 }
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
        guard sections.count == 0 else { return }
        let messageLabel = UILabel(frame: .zero)
        tableView.backgroundView?.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .top, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.text = message
    }
}
