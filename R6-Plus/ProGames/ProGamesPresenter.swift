//
//  ProGamesPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 30/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

class ProGamesPresenter {
    
    private weak var view: UBTableView?
    private var service = ProGamesService()
    
    private func setupProGames() {
        view?.registerCells([MatchTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchMatches()
    }
    
    func fetchMatches() {
        service.fetchProGames { [weak self] result in
            guard let `self` = self else { return }
            if case .success(let matches) = result {
                self.view?.setSections(self.generateMatchesSection(matches), isLoadMore: false)
            }
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded("No matches scheduled for these days")
            self.view?.reloadTableView()
        }
    }
    
    private func generateMatchesSection(_ matches: [Match]) -> [SectionComponent] {
        let cells = matches.map {
            CellComponent(reuseId: MatchTableViewCell.reuseId, data: generateMatchData($0), selectionHandler: {
                
            })}
        return [SectionComponent(header: nil, cells: cells)]
    }
    
    private func generateMatchData(_ match: Match) -> MatchCellData {
        return MatchCellData(tournamentName: match.tournament.name,
                             teamAImageUrl: match.team_a.imageUrl,
                             teamAName: match.team_a.name,
                             matchTime: match.playDate.toMatchTime(),
                             teamBImageUrl: match.team_b.imageUrl,
                             teamBName: match.team_b.name,
                             isLive: true)
    }
}

extension ProGamesPresenter: UBtableViewPresenter {
    
    func loadMoreInfo() {}
    
    func refreshControlAction() {
        view?.setSections([], isLoadMore: false)
        view?.reloadTableView()
        setupProGames()
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