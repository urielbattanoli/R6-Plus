//
//  OponentComparisonPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OponentComparisonPresenter: SearchPresenter {
    
    private let playerDetail: PlayerDetail
    private var videoWatched = false
    private var selectedPlayerId: String?
    
    init(service: SearchService, playerDetail: PlayerDetail) {
        self.playerDetail = playerDetail
        
        super.init(service: service)
    }
    
    override func searchPlayer(name: String, platform: String) {
        if name.isEmpty {
            showFavoritePlayers()
        } else {
            super.searchPlayer(name: name, platform: platform)
        }
    }
    
    override func setupSearch() {
        super.setupSearch()
        
        showFavoritePlayers()
    }
    
    private func showFavoritePlayers() {
        let favorites = R6UserDefaults.shared.favorites
        let players = PlayerDetail.fromDictionaryArray(favorites)
        let section = SectionComponent(header: nil,
                                       cells: players.map { self.playerToCellComponent($0.toSearchedPlayer()) })
        view?.setSections([section], isLoadMore: false)
        view?.stopLoading()
        view?.setEmptyMessageIfNeeded("")
        view?.reloadTableView()
    }
    
    override func playerToCellComponent(_ player: SearchedPlayer) -> CellComponent {
        let data = PlayerCellData(id: player.userId,
                                  imageUrl: player.imageUrl,
                                  name: player.nameOnPlatform,
                                  description: player.platformType)
        
        return CellComponent(reuseId: PlayerTableViewCell.reuseId, data: data) { [weak self] in
            self?.selectedPlayerId = player.userId
            self?.comparisonTouched()
        }
    }
    
    private func offerPremiumAccount() {
        configureIAP()
        let alert = UIAlertController(title: "You've reached the maximum number of comparisons today",
                                      message: "Upgrade your account to premium and make as many comparisons as you want! Also, remove all ads.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Buy", style: .default) { action in
            AnalitycsHelper.ComparisonBuyPremiumTouched.logEvent()
            IAPHelper.shared.purchaseMyProduct(index: 0)
        })
        alert.addAction(UIAlertAction(title: "Restore", style: .default) { action in
            AnalitycsHelper.ComparisonRestorePremiumTouched.logEvent()
            IAPHelper.shared.restorePurchase()
        })
        alert.addAction(UIAlertAction(title: "Free Comparison [Video Ads]", style: .default) { [weak self] action in
            AnalitycsHelper.ComparisonWatchVideoTouched.logEvent()
            guard let viewController = self?.view as? UIViewController else { return }
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: viewController)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            AnalitycsHelper.ComparisonBuyCanceled.logEvent()
        })
        (view as? UIViewController)?.present(alert, animated: true)
    }
    
    private func configureIAP() {
        IAPHelper.shared.fetchAvailableProducts()
        IAPHelper.shared.purchaseStatusBlock = { [weak self] message in
            let alert = UIAlertController(title: message,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            (self?.view as? UIViewController)?.present(alert, animated: true)
        }
    }
    
    private func comparisonTouched() {
        AnalitycsHelper.ComparisonTouched.logEvent()
        guard videoWatched || canMakeComparison() else {
            offerPremiumAccount()
            return
        }
        openComparison()
    }
    
    private func openComparison() {
        guard let playerId = selectedPlayerId else { return }
        videoWatched = false
        let comparePresenter = PlayerComparisonPresenter(leftPlayer: self.playerDetail, rightPlayerId: playerId)
        let compareVC = UBTableViewController(presenter: comparePresenter)
        (self.view as? UIViewController)?.navigationController?.pushViewController(compareVC, animated: true)
    }
    
    private func canMakeComparison() -> Bool {
        guard !R6UserDefaults.shared.premiumAccount else { return true }
        if let lastDate = R6UserDefaults.shared.freeComparison {
            return Date() > lastDate
        }
        return true
    }
}

private extension PlayerDetail {
    func toSearchedPlayer() -> SearchedPlayer {
        let apac = SearchedPlayer.Rank(mmr: self.rank.apac.mmr,
                                       rank: self.rank.apac.rank)
        let emea = SearchedPlayer.Rank(mmr: self.rank.emea.mmr,
                                       rank: self.rank.emea.rank)
        let ncsa = SearchedPlayer.Rank(mmr: self.rank.ncsa.mmr,
                                       rank: self.rank.ncsa.rank)
        let ranks = SearchedPlayer.Ranks(apac: apac,
                                         emea: emea,
                                         ncsa: ncsa)
        return SearchedPlayer(userId: self.id,
                              platformType: self.platform,
                              nameOnPlatform: self.name)
//        return SearchedPlayer(id: self.id,
//                              userId: self.userId,
//                              platform: self.platform,
//                              name: self.name,
//                              level: self.level,
//                              ranks: ranks)
    }
}

// MARK: - GADRewardBasedVideoAdDelegate
extension OponentComparisonPresenter: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        AnalitycsHelper.ComparisonVideoFullyWatched.logEvent()
        videoWatched = true
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        if videoWatched { openComparison() }
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: ADS_VIDEO_ID)
    }
}
