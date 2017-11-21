//
//  Firestore.swift
//  Tik Talk
//
//  Created by Developer on 11/18/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Firestore {
    static var base: Firestore {
        return Firestore.firestore()
    }
    
    static var posts: CollectionReference {
        return base.collection("posts")
    }
    
    static var users: CollectionReference {
        return base.collection("users")
    }
    
    static var groups: CollectionReference {
        return base.collection("groups")
    }
    
    static func referenceForPost(withID id: String) -> DocumentReference {
        return posts.document(id)
    }
    
    static func reference(for post: Post) -> DocumentReference {
        return Firestore.referenceForPost(withID: post.id)
    }
       
    static func referenceForUser(withID id: String) -> DocumentReference {
        return users.document(id)
    }
    
    static func reference(for user: User) -> DocumentReference {
        return Firestore.referenceForUser(withID: user.id)
    }
    
    static func friends(for user: User) -> CollectionReference {
        return Firestore.reference(for: user).collection("friends")
    }
}

