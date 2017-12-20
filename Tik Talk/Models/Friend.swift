//
//  Friend.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol FriendRef {
    var id: String { get }
}

struct Friend: Model, FriendRef {
    struct Reference: ModelReference, FriendRef {
        let id: String
        let dictionary: [String : Any]
    }
    let id: String
    
    let userReference: User.Reference
    
    let timestamp: Date
    
    var dictionary: [String : Any] {
        return [
            "timestamp" : timestamp,
            "userReference" : userReference.dictionary,
        ]
    }
    
    init(user: User.Reference) {
        self.id = user.id
        self.userReference = user
        self.timestamp = Date()
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.userReference = User.Reference(id: id, dictionary: dictionary["userReference"] as! [String : Any])
        self.timestamp = dictionary["timestamp"] as! Date
    }
}
