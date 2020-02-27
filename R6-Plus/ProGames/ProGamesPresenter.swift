//
//  ProGamesPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

private typealias strings = Strings.ProGames

class ProGamesPresenter {
    
    private weak var view: UBTableView?
    private var service = ProGamesService()
    private var page = 0
    private var currentDateIndex: Int?
    private var matches: [Match] = []
    
    private func setupProGames() {
        AnalitycsHelper.ProGamesOpened.logEvent()
        view?.registerCells([MatchTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchMatches()
        addSearchButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changePremiumStatus),
                                               name: .didBuyPremiumAccount,
                                               object: nil)
    }
    
    @objc private func changePremiumStatus() {
        view?.setSections(self.generateMatchesSection(matches), isLoadMore: true)
        view?.reloadTableView()
    }
    
    func fetchMatches() {
        service.fetchProGames() { [weak self] result in
            guard let self = self else { return }
            self.currentDateIndex = nil
            if case .success(let matches) = result {
                self.matches = matches
                self.view?.setSections(self.generateMatchesSection(matches), isLoadMore: true)
            }
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded(strings.noMatches)
            self.view?.reloadTableView()
            if let currentDateIndex = self.currentDateIndex {
                self.view?.scrollTo(indexPath: IndexPath(row: currentDateIndex, section: 0))
            }
        }
        page += 1
    }
    
    private func matchTouched(_ match: Match) {
        guard !R6UserDefaults.shared.premiumAccount,
            let date = match.playDate,
            date > Date() else { return }
        configureIAP()
        offerPremiumAccount()
    }
    
    private func offerPremiumAccount() {
        let alert = UIAlertController(title: Strings.Premium.premium,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.buy, style: .default) { action in
            AnalitycsHelper.PremiumAlertBuyTouched.logEvent()
            IAPHelper.shared.purchaseMyProduct(index: 0)
        })
        alert.addAction(UIAlertAction(title: Strings.restore, style: .default) { action in
            AnalitycsHelper.PremiumRestoreTouched.logEvent()
            IAPHelper.shared.restorePurchase()
        })
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel) { action in
            AnalitycsHelper.PremiumBuyCanceled.logEvent()
        })
        self.view?.present(alert, animated: true)
    }
    
    private func configureIAP() {
        IAPHelper.shared.fetchAvailableProducts()
        IAPHelper.shared.purchaseStatusBlock = { [weak self] message in
            let alert = UIAlertController(title: message,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.ok, style: .cancel))
            self?.view?.present(alert, animated: true)
        }
    }
    
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .cancel))
        view?.present(alert, animated: true)
    }
    
    private func generateMatchesSection(_ matches: [Match]) -> [SectionComponent] {
        var cells: [CellComponent] = []
        let matchs: [Match] = matches.sorted { return $0.playDate! > $1.playDate! }
        for i in 0..<matchs.count {
            let match = matchs[i]
            if let date = match.playDate, date > Date() {
                currentDateIndex = i
            }
            let cell = CellComponent(reuseId: MatchTableViewCell.reuseId,
                                     data: generateMatchData(match)) { [weak self] in
                                        self?.matchTouched(match)
            }
            cells.append(cell)
        }
        return [SectionComponent(header: nil, cells: cells)]
    }
    
    private func generateMatchData(_ match: Match) -> MatchCellData {
        var showBlur = false
        if !R6UserDefaults.shared.premiumAccount, let date = match.playDate {
            showBlur = date > Date()
        }
        let result = "\(match.teamAPoint) X \(match.teamBPoint)"
        return MatchCellData(tournamentName: match.league,
                             teamAImageUrl: match.teamA.image,
                             teamAName: match.teamA.name,
                             matchTime: match.playDate?.toMatchTime() ?? " - ",
                             teamBImageUrl: match.teamB.image,
                             teamBName: match.teamB.name,
                             result: result,
                             isLive: false,
                             blurCell: showBlur)
    }
    
    private func addSearchButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched))
        view?.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func searchButtonTouched() {
        let presenter = SearchPresenter(service: SearchService())
        SearchRouter.openSearch(viewController: view, presenter: presenter)
    }
}

extension ProGamesPresenter: UBTableViewPresenter {
    
    func loadMoreInfo() {}
    
    func refreshControlAction() {
        view?.setSections([], isLoadMore: false)
        view?.reloadTableView()
        page = 0
        fetchMatches()
    }
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupProGames()
    }
    
    func viewdidAppear() {
        view?.reloadTableView()
    }
    
    func viewWillDisappear() {}
}
