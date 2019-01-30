//
//  NewsService.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 28/01/19.
//  Copyright © 2019 Mocka. All rights reserved.
//

import Foundation

enum Language: String {
    case en
    case pt
    case de
    case fr
    
    var menuName: String {
        return self.rawValue.localizedUppercase
    }
    
    var params: [String: Any] {
        return ["language": self.rawValue]
    }
}

class NewsService {
    
    func fetchNews(input: Language, completion: @escaping ((Result<[News]>) -> Void)) {
        R6API.news(input: input).request { result in
            switch result {
            case .success(let json):
                guard let result = json["result"] as? [[String: Any]] else {
                    completion(.failure(nil))
                    return
                }
                completion(.success(News.fromDictionaryArray(result)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
