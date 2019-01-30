//
//  MainPaginationPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 25/01/19.
//  Copyright © 2019 Mocka. All rights reserved.
//

import Foundation

enum MainPaginationType {
    case leaderboard, news
}

class MainPaginationPresenter {
    
    let type: MainPaginationType
    weak var view: MainPaginationView?
    
    init(type: MainPaginationType) {
        self.type = type
    }
    
    func attachView(_ view: MainPaginationView) {
        self.view = view
        
        switch type {
        case .leaderboard:
            setupForLeaderboard()
        case .news:
            setupForNews()
        }
    }
    
    private func setupForLeaderboard() {
        let items = [Region.global.menuName,
                     Region.apac.menuName,
                     Region.emea.menuName,
                     Region.ncsa.menuName]
        
        let vcd1 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .global)
        let vc1 = UBTableViewController(presenter: vcd1)
        vc1.index = 0
        let vcd2 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .apac)
        let vc2 = UBTableViewController(presenter: vcd2)
        vc2.index = 1
        let vcd3 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .emea)
        let vc3 = UBTableViewController(presenter: vcd3)
        vc3.index = 2
        let vcd4 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .ncsa)
        let vc4 = UBTableViewController(presenter: vcd4)
        vc4.index = 3
        let vcs = [vc1, vc2, vc3, vc4]
        
        let viewModel = MainPaginationViewModel(menuItems: items,
                                                viewControllers: vcs)
        view?.setupView(viewModel: viewModel)
    }
    
    private func setupForNews() {
        let items = [Language.en.menuName,
                     Language.pt.menuName,
                     Language.de.menuName,
                     Language.fr.menuName]
        
        let vcd1 = NewsPresenter(service: NewsService(), language: .en)
        let vc1 = UBTableViewController(presenter: vcd1)
        vc1.index = 0
        let vcd2 = NewsPresenter(service: NewsService(), language: .pt)
        let vc2 = UBTableViewController(presenter: vcd2)
        vc2.index = 1
        let vcd3 = NewsPresenter(service: NewsService(), language: .de)
        let vc3 = UBTableViewController(presenter: vcd3)
        vc3.index = 2
        let vcd4 = NewsPresenter(service: NewsService(), language: .fr)
        let vc4 = UBTableViewController(presenter: vcd4)
        vc4.index = 3
        let vcs = [vc1, vc2, vc3, vc4]
        
        let viewModel = MainPaginationViewModel(menuItems: items,
                                                viewControllers: vcs)
        view?.setupView(viewModel: viewModel)
    }
}
