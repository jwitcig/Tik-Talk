//
//  Group.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol GroupReference: ModelReference { }

struct Group: Model, GroupReference {
    struct Core: ModelCore, GroupReference {
        let id: String
        let dictionary: [String : Any]
        var name: String {
            return dictionary["name"] as! String
        }
    }
    
    let id: String
    let timestamp: Date
    let creatorID: String
    
    let name: String
    let memberCount: Int

    var dictionary: [String: Any] {
        return [
            "name" : name,
            "creatorID" : creatorID,
            "timestamp" : timestamp,
            "memberCount" : memberCount,
        ]
    }
    
    init(name: String, creator: UserReference) {
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

protocol ValidatesGroups: ValidatesModels {
    var group: Group { get }
}

extension ValidatesGroups {
    var isValid: Bool {
        return group.name.count >= 3
    }
}
