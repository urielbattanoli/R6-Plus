//
//  OponentSelectionPresenter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds

private typealias strings = Strings.OponentSelection

class OponentSelectionPresenter: SearchPresenter {
    
    private let playerDetail: PlayerDetail
    private var videoWatched = false
    private var selectedPlayer: SearchedPlayer?
    
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
        let data = PlayerCellData(imageUrl: player.imageUrl,
                                  name: player.nameOnPlatform,
                                  description: player.platformType)
        
        return CellComponent(reuseId: PlayerTableViewCell.reuseId, data: data) { [weak self] in
            self?.selectedPlayer = player
            self?.comparisonTouched()
        }
    }
    
    private func offerPremiumAccount() {
        configureIAP()
        let alert = UIAlertController(title: strings.reachedMaximum,
                                      message: strings.upgradeAccount,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.buy, style: .default) { action in
            AnalitycsHelper.ComparisonBuyPremiumTouched.logEvent()
            IAPHelper.shared.purchaseMyProduct(index: 0)
        })
        alert.addAction(UIAlertAction(title: Strings.restore, style: .default) { action in
            AnalitycsHelper.ComparisonRestorePremiumTouched.logEvent()
            IAPHelper.shared.restorePurchase()
        })
        alert.addAction(UIAlertAction(title: strings.freeComp, style: .default) { [weak self] action in
            AnalitycsHelper.ComparisonWatchVideoTouched.logEvent()
            guard let viewController = self?.view as? UIViewController else { return }
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: viewController)
            }
        })
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel) { action in
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
            alert.addAction(UIAlertAction(title: Strings.ok, style: .cancel))
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
        guard let player = selectedPlayer else { return }
        videoWatched = false
        let platform = Platform(rawValue: player.platformType) ?? .pc
        let comparePresenter = PlayerComparisonPresenter(leftPlayer: self.playerDetail,
                                                         rightPlayerId: player.profileId,
                                                         name: player.nameOnPlatform,
                                                         platform: platform)
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
        return SearchedPlayer(profileId: self.id,
                              platformType: self.platform,
                              nameOnPlatform: self.name)
    }
}

// MARK: - GADRewardBasedVideoAdDelegate
extension OponentSelectionPresenter: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        AnalitycsHelper.ComparisonVideoFullyWatched.logEvent()
        videoWatched = true
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        if videoWatched { openComparison() }
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: ADS_COMP_ID)
    }
}
