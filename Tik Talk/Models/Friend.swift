//
//  Friend.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol FriendReference: ModelReference { }

struct Friend: Model, FriendReference {
    struct Core: ModelCore, FriendReference {
        let id: String
        let dictionary: [String : Any]
    }
    let id: String
    let timestamp: Date

    let userCore: User.Core
    
    var dictionary: [String : Any] {
        return [
            "timestamp" : timestamp,
            "userCore" : userCore.dictionary,
        ]
    }
    
    init(user: User.Core) {
        self.id = user.id
        self.timestamp = Date()

        self.userCore = user
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.timestamp = dictionary["timestamp"] as! Date

        self.userCore = User.Core(id: id, dictionary: dictionary["userCore"] as! [String : Any])
    }
}
