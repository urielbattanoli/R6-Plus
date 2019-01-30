//
//  NewsPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 28/01/19.
//  Copyright © 2019 Mocka. All rights reserved.
//

import UIKit

private typealias strings = Strings.Leaderboard

class NewsPresenter {
    
    private let service: NewsService
    private weak var view: UBTableView?
    private var language: Language
    
    init(service: NewsService, language: Language) {
        self.service = service
        self.language = language
    }
    
    private func setupNews() {
        view?.registerCells([NewsTableViewCell.self])
        view?.addRefreshControl()
        view?.startLoading()
        fetchNewsList()
    }
    
    private func openNewsUrl(url: String) {
        guard let url = URL(string: url),
            UIApplication.shared.canOpenURL(url) else {
                showAlertWithMessage(Strings.errorOpenUrl)
                return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .cancel))
        (view as? UIViewController)?.present(alert, animated: true)
    }
    
    
    private func fetchNewsList() {
        service.fetchNews(input: language) { [weak self] result in
            guard let `self` = self else { return }
            if case(.success(let news)) = result {
                let newsList = self.newsToCellComponents(news)
                let section = SectionComponent(header: nil, cells: newsList)
                self.view?.setSections([section], isLoadMore: true)
            }
            self.view?.stopLoading()
            self.view?.setEmptyMessageIfNeeded(strings.maintenance)
            self.view?.reloadTableView()
        }
    }
    
    private func newsToCellComponents(_ news: [News]) -> [CellComponent] {
        return news.map {
            let media = $0.entities.media?.first
            let url = $0.entities.urls.first?.url ?? ""
            let data = NewsCellData(photoUrl: $0.user.profile_image_url_https,
                                    name: $0.user.name,
                                    screenName: $0.user.screen_name,
                                    date: $0.created_at.toNewsDate()?.toNewsTime() ?? "",
                                    message: $0.text,
                                    mediaUrl: media?.media_url_https ?? "",
                                    mediaHeight: media?.sizes.small.h ?? 0,
                                    mediaWidth: media?.sizes.small.w ?? 0)
            return CellComponent(reuseId: NewsTableViewCell.reuseId,
                                 data: data) { [weak self] in
                                    self?.openNewsUrl(url: url)
            }
        }
    }
}

// MARK: - UBtableViewPresenter
extension NewsPresenter: UBTableViewPresenter {
    
    func attachView(_ view: UBTableView) {
        self.view = view
        setupNews()
    }
    
    func loadMoreInfo() { }
    
    func refreshControlAction() {
        view?.setSections([], isLoadMore: false)
        view?.reloadTableView()
        fetchNewsList()
    }
    
    func viewdidAppear() {}
    
    func viewWillDisappear() {}
}
