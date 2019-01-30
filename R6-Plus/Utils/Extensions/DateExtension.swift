//
//  DateExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

extension Date {
    
    func toString() -> String {
        return Utils.defaultDateFormatter.string(from: self)
    }
    
    func nextDay() -> Date? {
        let caledar = Utils.defaultDateFormatter.calendar
        return caledar?.date(byAdding: .day, value: 1, to: self)
    }
    
    func toMatchTime() -> String {
        let text = Utils.matchDateFormatter.string(from: self)
        return text.replacingOccurrences(of: ":", with: "h")
    }
    
    func toNewsTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM - HH:mm"
        let text = formatter.string(from: self)
        return text.replacingOccurrences(of: ":", with: "h")
    }
}
