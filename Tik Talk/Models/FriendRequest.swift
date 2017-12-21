//
//  FriendRequest.swift
//  Tik Talk
//
//  Created by Developer on 12/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol FriendRequestRef {
    var id: String { get }
}

struct FriendRequest: Model, FriendRequestRef {
    enum Target {
        case sender, recipient
    }
    
    struct Reference: ModelReference, FriendRequestRef {
        let id: String
        let dictionary: [String : Any]
    }
    
    let id: String
    
    let isRecipient: Bool
    let userReference: User.Reference
    
    let timestamp: Date
    
    var dictionary: [String : Any] {
        return [
            "isRecipient" : isRecipient,
            "timestamp" : timestamp,
            "userReference" : userReference.dictionary,
        ]
    }
    
    init(associatedUser user: User.Reference, isRecipient: Bool) {
        self.id = user.id
        self.timestamp = Date()

        self.isRecipient = isRecipient
        self.userReference = user
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.timestamp = dictionary["timestamp"] as! Date

        self.isRecipient = dictionary["isRecipient"] as! Bool
        self.userReference = User.Reference(id: id, dictionary: dictionary["userReference"] as! [String : Any])
    }
}
