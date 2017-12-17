//
//  Profile.swift
//  Tik Talk
//
//  Created by Developer on 11/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

struct Profile {
    let bio: String?
    let birthday: String?
    
    let friendsCount: Int
    
    var dictionary: [String : Any] {
        return [
            "bio" : bio ?? "",
            "birthday": birthday ?? "",
        ]
    }
    
    init(bio: String?, birthday: String?, friendsCount: Int) {
        self.bio = bio
        self.birthday = birthday
        self.friendsCount = friendsCount
    }
    
    init(dictionary: [String : Any]) {
        self.bio = dictionary["bio"] as? String
        self.birthday = dictionary["birthday"] as? String
        self.friendsCount = dictionary["friendsCount"] as? Int ?? 0
    }
}
