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
//    let user: User
    let content: String
    let fromId: String
    let toId: String
    
    let fromFullname: String
    let fromProfileImageUrl: String
    let creationDate: Date
//    let isPositive: Bool
    
    var hasLiked = false
    
    init(dictionary: [String: Any]) {
//        self.user = user
        self.id = dictionary["id"] as? Int ?? 0
        self.content = dictionary["content"] as? String ?? ""
        self.fromId = dictionary["from"] as? String ?? ""
        self.toId = dictionary["to"] as? String ?? ""
//        self.isPositive = dictionary["isPositive"] as? Bool ?? false
        
        let secondsFrom1970 = dictionary["createdAt"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
        // Retrieve sender info
        let sender = dictionary["sender"] as! NSDictionary
        self.fromFullname = sender["fullname"] as? String ?? ""
        self.fromProfileImageUrl = sender["avatarUrl"] as? String ?? ""
        
    }
}



