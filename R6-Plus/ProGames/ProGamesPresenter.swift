//
//  ProGamesPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class ProGamesPresenter {
    
    private weak var view: UBTableView?
    private var service = ProGamesService()
    private var page = 0
    
    private func setupProGames() {
        AnalitycsHelper.ProGamesOpened.logEvent()
        view?.registerCells([MatchTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchMatches()
        addSearchButton()
    }
    
    func fetchMatches() {
        let input = ProGamesInput(limit: 15, page: page)
        service.fetchProGames(input: input) { [weak self] result in
            guard let `self` = self else { return }
            if case .success(let matches) = result {
                self.view?.setSections(self.generateMatchesSection(matches), isLoadMore: true)
            }
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded("No matches scheduled for these days")
            self.view?.reloadTableView()
        }
        page += 1
    }
    
    private func matchTouched(_ match: Match) {
        AnalitycsHelper.MatchTouched.logEvent(obs: match.objectId)
        
        guard let url = URL(string: match.streamUrl ?? ""),
            match.isLive && UIApplication.shared.canOpenURL(url) else {
            streamNotAvailable()
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func streamNotAvailable() {
        let alert = UIAlertController(title: nil, message: "This stream is currently not available!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        (view as? UIViewController)?.present(alert, animated: true)
    }
    
    private func generateMatchesSection(_ matches: [Match]) -> [SectionComponent] {
        let cells = matches.map { [weak self] match in
            CellComponent(reuseId: MatchTableViewCell.reuseId, data: generateMatchData(match)) {
                self?.matchTouched(match)
            }
        }
        return [SectionComponent(header: nil, cells: cells)]
    }
    
    private func generateMatchData(_ match: Match) -> MatchCellData {
        return MatchCellData(tournamentName: match.tournament.name,
                             teamAImageUrl: match.team_a.imageUrl,
                             teamAName: match.team_a.name,
                             matchTime: match.playDate.toMatchTime(),
                             teamBImageUrl: match.team_b.imageUrl,
                             teamBName: match.team_b.name,
                             isLive: match.isLive)
    }
    
    private func addSearchButton() {
        guard let viewController = view as? UIViewController else { return }
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTouched))
        viewController.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func searchButtonTouched() {
        SearchRouter.openSearch(viewController: view as? UIViewController)
    }
}

extension ProGamesPresenter: UBtableViewPresenter {
    
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
