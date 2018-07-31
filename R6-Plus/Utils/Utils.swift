//
//  Utils.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 24/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct Utils {
    
    static func className(for _class: AnyClass) -> String {
        let str = String(describing: type(of: _class))
        guard str.hasSuffix(".Type") else {
            return str
        }
        return String(str[..<str.index(str.endIndex, offsetBy: -5)])
    }
    
    static let defaultDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static let matchDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM\nhh:mm"
        return dateFormatter
    }()

    static let attackersOperators: [String] = {
        return ["Ash",
                "Blitz",
                "Buck",
                "Capitao",
                "Dokkaebi",
                "Finka",
                "Frost",
                "Fuze",
                "Glaz",
                "Hibana",
                "IQ",
                "Jackal",
                "Lion",
                "Montagne",
                "Sledge",
                "Thatcher",
                "Thermite",
                "Twitch",
                "Zofia"]
    }()
    
    static let defendersOperators: [String] = {
        return ["Bandit",
                "Blackbeard",
                "Castle",
                "Caveira",
                "Doc",
                "Echo",
                "Ela",
                "Jager",
                "Kapkan",
                "Lesion",
                "Mira",
                "Mute",
                "Pulse",
                "Rook",
                "Smoke",
                "Tachanka",
                "Valkyrie",
                "Vigil",
                "Ying"]
    }()
}
