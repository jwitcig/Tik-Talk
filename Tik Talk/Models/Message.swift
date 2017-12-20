//
//  Message.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol MessageRef {
    var id: String { get }
}

struct Message: Model, MessageRef {
    struct Reference: ModelReference, MessageRef {
        let id: String
        let dictionary: [String : Any]
    }
    
    let id: String
    
    let creatorID: String
    let body: String
    
    let timestamp: Date
    
    var dictionary: [String : Any] {
        return [
            "timestamp" : timestamp,
            "creatorID" : creatorID,
            "body" : body,
        ]
    }
    
    init(creator: UserRef, body: String) {
        self.id = Message.uniqueID()
        self.timestamp = Date()
        self.creatorID = creator.id
        
        self.body = body
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.timestamp = dictionary["timestamp"] as! Date
        self.creatorID = dictionary["creatorID"] as! String
        
        self.body = dictionary["body"] as! String
    }
}
