//
//  User.swift
//  ReputationApp
//
//  Created by Omar Torres on 28/05/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import Foundation

struct User {
    
    let id: String
    let fullname: String
    let username: String
//    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
