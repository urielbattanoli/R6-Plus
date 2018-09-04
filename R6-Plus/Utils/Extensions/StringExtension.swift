//
//  StringExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 12/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    var formattedStringDate: String {
        let substring = String(self.prefix(10))
        guard let date = Utils.defaultDateFormatter.date(from: substring) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}
