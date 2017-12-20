//
//  FriendRequest.swift
//  Tik Talk
//
//  Created by Developer on 12/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Firebase

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
    let handle: String
    
    let timestamp: Date
    
    var dictionary: [String : Any] {
        return [
            "isRecipient" : isRecipient,
            "timestamp" : timestamp,
            "handle" : handle,
        ]
    }
    
    init(associatedUser user: UserRef, isRecipient: Bool, handle: String) {
        self.id = user.id
        self.isRecipient = isRecipient
        self.handle = handle
        self.timestamp = Date()
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.isRecipient = dictionary["isRecipient"] as! Bool
        self.handle = dictionary["handle"] as! String
        self.timestamp = dictionary["timestamp"] as! Date
    }
}
