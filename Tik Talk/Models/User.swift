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
    static var currentUser: User?
    
    let id: String
    let handle: String
    let email: String?
    
    let friendsCount: Int
    
    var profile: Profile?
    
    var dictionary: [String : Any] {
        return [
            "handle" : handle,
             "email" : email ?? "",
        ]
    }
    
    init(id: String, handle: String, profile: Profile? = nil, other: [String : Any]?) {
        var dictionary = other ?? [:]
        dictionary["handle"] = handle
        dictionary["profile"] = profile?.dictionary
        self.init(id: id, dictionary: dictionary)
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.handle = dictionary["handle"] as! String
        
        self.email = dictionary["email"] as? String
        
        self.friendsCount = dictionary["friendsCount"] as? Int ?? 0

        if let data = dictionary["profile"] as? [String : Any] {
            self.profile = Profile(dictionary: data)
        } else {
            self.profile = nil
        }
    }
}
