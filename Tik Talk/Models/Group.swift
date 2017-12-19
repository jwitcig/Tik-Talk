//
//  Group.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

struct Group: Model {
    struct Reference: ModelReference {
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
            "timestamp" : timestamp.utc,
            "memberCount" : memberCount,
        ]
    }
    
    init(id: String, name: String, creator: User, timestamp: Date = Date()) {
        self.init(id: id, name: name, creatorID: creator.id, timestamp: timestamp)
    }
    
    init(id: String, name: String, creatorID: String, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.creatorID = creatorID
        self.timestamp = timestamp
        self.memberCount = 0
    }

    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.name = dictionary["name"] as! String
        self.creatorID = dictionary["creatorID"] as! String
        self.timestamp = Date(utc: dictionary["timestamp"] as! String)
        self.memberCount = dictionary["memberCount"] as! Int
    }
}

extension Group {
    class Generator {
        static func fake() -> Group {
            return Group(id: randomString(length: 20), name: randomString(length: 20), creatorID: randomString(length: 20))
        }
    }
}
