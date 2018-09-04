//
//  CodableExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 24/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self.self)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return json as? [String: Any] ?? [:]
    }
}

extension Decodable {
    static func fromDictionary(_ dictionary: [String: Any]) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return try JSONDecoder().decode(self.self, from: data)
    }
    
    static func fromDictionaryArray(_ dictArray: [[String: Any]]?) -> [Self] {
        guard let dictArray = dictArray else { return [] }
        return dictArray.compactMap { try? fromDictionary($0) }
    }
}
