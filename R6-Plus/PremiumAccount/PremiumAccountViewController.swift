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
    @IBOutlet private weak var buyButton: UIButton! {
        didSet {
            buyButton.setCorner(value: 5)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        messageLabel.text = "You already own a Premium Account!\n\nThank you for your support!"
        buyButton.isHidden = true
    }
    
    private func offerPremiumAccount() {
        configureIAP()
        let alert = UIAlertController(title: "Premium Account",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Buy", style: .default) { action in
            AnalitycsHelper.PremiumAlertBuyTouched.logEvent()
            IAPHelper.shared.purchaseMyProduct(index: 0)
        })
        alert.addAction(UIAlertAction(title: "Restore", style: .default) { action in
            AnalitycsHelper.PremiumRestoreTouched.logEvent()
            IAPHelper.shared.restorePurchase()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
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
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
    @IBAction private func didTouchBuyButton(_ sender: UIButton) {
        AnalitycsHelper.PremiumBuyTouched.logEvent()
        configureIAP()
        offerPremiumAccount()
    }
}
