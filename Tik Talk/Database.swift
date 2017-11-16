//
//  Database.swift
//  Tik Talk
//
//  Created by Developer on 11/12/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    static var base: DatabaseReference {
        return Database.database().reference()
    }
    
    static var posts: DatabaseReference {
        return base.child("posts")
    }
    
    static var users: DatabaseReference {
        return base.child("users")
    }
    
    static func referenceForPost(withID id: String) -> DatabaseReference {
        return posts.child(id)
    }
    
    static func reference(for post: Post) -> DatabaseReference {
        return Database.referenceForPost(withID: post.id)
    }
    
    static func referenceForMetaVotes(for post: Post) -> DatabaseReference {
        return Database.referenceForMetaVotes(forPostID: post.id)
    }
    
    static func referenceForMetaVotes(forPostID id: String) -> DatabaseReference {
        return Database.referenceForPost(withID: id).child("metaVotes")
    }
    
    static func referenceForUser(withID id: String) -> DatabaseReference {
        return users.child(id)
    }
}

