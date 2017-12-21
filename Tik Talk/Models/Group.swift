//
//  Group.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol GroupRef {
    var id: String { get }
}

struct Group: Model, GroupRef {
    struct Reference: ModelReference, GroupRef {
        let id: String
        let dictionary: [String : Any]
        var name: String {
            return dictionary["name"] as! String
        }
    }
    
    let id: String
    let name: String
    let creatorID: String
    let timestamp: Date
    let memberCount: Int

    var dictionary: [String: Any] {
        return [
            "name" : name,
            "creatorID" : creatorID,
            "timestamp" : timestamp,
            "memberCount" : memberCount,
        ]
    }
    
    init(name: String, creator: UserRef) {
        self.id = Group.uniqueID()
        self.timestamp = Date()
        self.creatorID = creator.id

        self.name = name
        self.memberCount = 0
    }

    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.timestamp = Date(utc: dictionary["timestamp"] as! String)
        self.creatorID = dictionary["creatorID"] as! String

        self.name = dictionary["name"] as! String
        self.memberCount = dictionary["memberCount"] as! Int
    }
}
