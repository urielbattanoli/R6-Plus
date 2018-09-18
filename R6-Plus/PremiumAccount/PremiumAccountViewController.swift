//
//  PremiumAccountViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 19/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class PremiumAccountViewController: UIViewController {

    @IBOutlet private weak var premiumImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton.setCorner(value: 5)
        buyButton.setTitle(Strings.Premium.buyNow, for: .normal)
        messageLabel.text = Strings.Premium.helpUs
        guard !R6UserDefaults.shared.premiumAccount else {
            changePremiumStatus()
            return
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changePremiumStatus),
                                               name: .didBuyPremiumAccount,
                                               object: nil)
        AnalitycsHelper.PremiumOpened.logEvent()
    }
    
    @objc private func changePremiumStatus() {
        premiumImageView.image = #imageLiteral(resourceName: "premium")
        messageLabel.text = Strings.Premium.thanksMessage
        buyButton.isHidden = true
    }
    
    private func offerPremiumAccount() {
        configureIAP()
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
        present(alert, animated: true)
    }
    
    private func configureIAP() {
        IAPHelper.shared.fetchAvailableProducts()
        IAPHelper.shared.purchaseStatusBlock = { [weak self] message in
            let alert = UIAlertController(title: message,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.ok, style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
    @IBAction private func didTouchBuyButton(_ sender: UIButton) {
        AnalitycsHelper.PremiumBuyTouched.logEvent()
        configureIAP()
        offerPremiumAccount()
    }
}
