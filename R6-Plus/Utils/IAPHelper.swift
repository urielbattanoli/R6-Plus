//
//  IAPHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType {
    case disabled
    case restored(success: Bool)
    case purchased
    case failure(error: Error?)
    
    func message() -> String {
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored(let success): return success ?  "You've successfully restored your purchase!" : "You can't restore a purchase you haven't made"
        case .purchased: return"You've successfully bought this purchase!"
        case .failure(let error): return error?.localizedDescription ?? "Something went wrong! Try again "
        }
    }
}

class IAPHelper: NSObject {
    static let shared = IAPHelper()
    
    private let PREMIUM_ACCOUNT_PRODUCT_ID = "com.mocka.R6Plus.PremiumAccount"
    private var productsRequest = SKProductsRequest()
    private var iapProducts = [SKProduct]()
    private var canMakePurchases: Bool { return SKPaymentQueue.canMakePayments() }
    
    var purchaseStatusBlock: ((String) -> Void)?
    
    func purchaseMyProduct(index: Int) {
        guard iapProducts.count > index else { return }
        
        if canMakePurchases {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            let type: IAPHandlerAlertType = .disabled
            R6UserDefaults.shared.premiumAccount = false
            AnalitycsHelper.PremiumBuyDisabled.logEvent()
            purchaseStatusBlock?(type.message())
        }
    }
    
    func restorePurchase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts() {
        guard let productIdentifiers = NSSet(objects: PREMIUM_ACCOUNT_PRODUCT_ID) as? Set<String> else { return }
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

// MARK: - SKProductsRequestDelegate
extension IAPHelper: SKProductsRequestDelegate {
    
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard response.products.count > 0 else { return }
        iapProducts = response.products
    }
}

// MARK: - SKPaymentTransactionObserver
extension IAPHelper: SKPaymentTransactionObserver {
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let transactionId = queue.transactions.first?.original?.payment.productIdentifier ?? ""
        let productAlreadyBought = transactionId == PREMIUM_ACCOUNT_PRODUCT_ID
        if productAlreadyBought {
            AnalitycsHelper.PremiumRestored.logEvent()
        } else {
            AnalitycsHelper.PremiumRestoredFailed.logEvent()
        }
        let type: IAPHandlerAlertType = .restored(success: productAlreadyBought)
        R6UserDefaults.shared.premiumAccount = productAlreadyBought
        purchaseStatusBlock?(type.message())
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                let type: IAPHandlerAlertType = .purchased
                R6UserDefaults.shared.premiumAccount = true
                AnalitycsHelper.PremiumBought.logEvent()
                purchaseStatusBlock?(type.message())
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                let type: IAPHandlerAlertType = .restored(success: true)
                R6UserDefaults.shared.premiumAccount = true
                AnalitycsHelper.PremiumRestored.logEvent()
                purchaseStatusBlock?(type.message())
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                let type: IAPHandlerAlertType = .failure(error: transaction.error)
                R6UserDefaults.shared.premiumAccount = false
                AnalitycsHelper.PremiumBuyFailed.logEvent()
                purchaseStatusBlock?(type.message())
            default: break
            }
        }
    }
}
