//
//  Review.swift
//  ReputationApp
//
//  Created by Omar Torres on 30/07/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import Foundation

struct Review {
    
    let id: Int
    let event_url: String
    let description: String
    let user_avatar_url: String
    let created_at: Date
    
    init(id: Int, dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.description = dictionary["description"] as? String ?? ""
        self.event_url = dictionary["event_url"] as? String ?? ""
        self.user_avatar_url = dictionary["user_avatar_url"] as? String ?? ""
        let secondsFrom1970 = dictionary["created_at"] as? Double ?? 0
        self.created_at = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}



