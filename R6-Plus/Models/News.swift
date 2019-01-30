//
//  News.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 28/01/19.
//  Copyright © 2019 Mocka. All rights reserved.
//

import Foundation

struct News: Codable {
    let text: String
    let created_at: String
    let entities: Entities
    let user: User
    
    struct Entities: Codable {
        let urls: [Urls]
        let media: [Media]?
    }
    
    struct Urls: Codable {
        let url: String
    }
    
    struct Media: Codable {
        let media_url_https: String
        let sizes: Sizes
        
        struct Sizes: Codable {
            let small: Small
            
            struct Small: Codable {
                let w: Double
                let h: Double
            }
        }
    }
    
    struct User: Codable {
        let name: String
        let screen_name: String
        let profile_image_url_https: String
    }
}
