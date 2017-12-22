//
//  FriendRequest.swift
//  Tik Talk
//
//  Created by Developer on 12/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol FriendRequestReference: ModelReference { }

struct FriendRequest: Model, FriendRequestReference {
    enum Target {
        case sender, recipient
    }
    
    struct Core: ModelCore, FriendRequestReference {
        let id: String
        let dictionary: [String : Any]
    }
    
    let id: String
    
    let isRecipient: Bool
    let userCore: User.Core
    
    let timestamp: Date
    
    var dictionary: [String : Any] {
        return [
            "isRecipient" : isRecipient,
            "timestamp" : timestamp,
            "userCore" : userCore.dictionary,
        ]
    }
    
    init(associatedUser user: User.Core, isRecipient: Bool) {
        self.id = user.id
        self.timestamp = Date()

        self.isRecipient = isRecipient
        self.userCore = user
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.timestamp = dictionary["timestamp"] as! Date

        self.isRecipient = dictionary["isRecipient"] as! Bool
        self.userCore = User.Core(id: id, dictionary: dictionary["userCore"] as! [String : Any])
    }
}
