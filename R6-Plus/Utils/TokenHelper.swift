//
//  TokenHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 31/08/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import RxSwift

struct UbiToken: Codable {
    let ticket: String
    
    func header() -> [String: String] {
        return ["Ubi-AppId": "39baebad-39e5-4552-8c25-2c9b919064e2",
                "Authorization": "Ubi_v1 t=\(ticket)"]
    }
}

class TokenHelper {
    
    static var token: UbiToken?
    private static var timer = Timer()
    private static var disposeBag = DisposeBag()
    
    @objc static func validUbiToken() {
        R6API.getToken.rxRequest().retry(3).subscribe(onNext: { json in
            let token = try? UbiToken.fromDictionary(json)
            self.token = token
        }).disposed(by: disposeBag)
        scheduleTimer()
    }
    
    static private func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60 * 60 * 2,
                                     target: self,
                                     selector: #selector(validUbiToken),
                                     userInfo: nil,
                                     repeats: false)
    }
}
