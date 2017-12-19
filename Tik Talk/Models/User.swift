//
//  User.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

struct User: Model {
    struct Reference: ModelReference {
        let id: String
        let dictionary: [String : Any]
        var name: String {
            return dictionary["name"] as! String
        }
    }
    
    static var currentUser: User?
    
    let id: String
    let handle: String
    let email: String?
    
    let bio: String?
    var birthday: String?
    
    let friendsCount: Int

    var reference: User.Reference {
        return User.Reference(id: id, dictionary: dictionary)
    }
    
    var dictionary: [String : Any] {
        return [
            "handle" : handle,
            "email" : email ?? "",
            "bio" : bio ?? "",
            "birthday" : birthday ?? "",
        ]
    }
    
    init(id: String, handle: String, other: [String : Any]?) {
        var dictionary = other ?? [:]
        dictionary["handle"] = handle
        self.init(id: id, dictionary: dictionary)
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.handle = dictionary["handle"] as! String
        
        self.email = dictionary["email"] as? String
        
        self.bio = dictionary["bio"] as? String
        self.birthday = dictionary["birthday"] as? String
        self.friendsCount = dictionary["friendsCount"] as? Int ?? 0
    }
}
