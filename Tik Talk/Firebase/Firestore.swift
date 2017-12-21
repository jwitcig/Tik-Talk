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

    static var friendRequests: CollectionReference {
        return base.collection("friendRequests")
    }
    
    static var conversations: CollectionReference {
        return base.collection("conversations")
    }
    
    static func uniqueID() -> String {
        return Firestore.base.collection("0").document().documentID
    }
    
    static func referenceForPost(withID id: String) -> DocumentReference {
        return posts.document(id)
    }
    
    static func reference(for post: PostRef) -> DocumentReference {
        return Firestore.referenceForPost(withID: post.id)
    }
       
    static func referenceForUser(withID id: String) -> DocumentReference {
        return users.document(id)
    }
    
    static func reference(for user: UserRef) -> DocumentReference {
        return Firestore.referenceForUser(withID: user.id)
    }
    
    static func reference(for group: GroupRef) -> DocumentReference {
        return Firestore.groups.document(group.id)
    }
    
    static func friends(for user: UserRef) -> CollectionReference {
        return Firestore.reference(for: user).collection("friends")
    }
}
