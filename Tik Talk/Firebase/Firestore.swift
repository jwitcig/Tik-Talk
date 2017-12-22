//
//  Firestore.swift
//  Tik Talk
//
//  Created by Developer on 11/18/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

func collectionName<T: Model>(for model: T.Type) -> String {
    switch model {
    case is Post.Type: return "posts"
    case is User.Type: return "users"
    case is Group.Type: return "groups"
    case is Friend.Type: return "friends"
    case is FriendRequest.Type: return "friendRequests"
    case is Conversation.Type: return "conversations"
    default: fatalError()
    }
}

extension Firestore {
    static var base: Firestore {
        return Firestore.firestore()
    }
}

extension Firestore {
    static func collection<T: Model>(of type: T.Type) -> CollectionReference {
        return base.collection(collectionName(for: type))
    }
    
    static func referenceForPost(withID id: String) -> DocumentReference {
        return collection(of: Post.self).document(id)
    }
    
    static func reference(for post: PostReference) -> DocumentReference {
        return Firestore.referenceForPost(withID: post.id)
    }
       
    static func referenceForUser(withID id: String) -> DocumentReference {
        return collection(of: User.self).document(id)
    }
    
    static func reference(for user: UserReference) -> DocumentReference {
        return Firestore.referenceForUser(withID: user.id)
    }
    
    static func reference(for group: GroupReference) -> DocumentReference {
        return collection(of: Group.self).document(group.id)
    }
    
    static func friends(for user: UserReference) -> CollectionReference {
        return Firestore.reference(for: user).collection("friends")
    }
    
    static func reference(for conversation: ConversationReference) -> DocumentReference {
        return collection(of: Conversation.self).document(conversation.id)
    }
}

extension Firestore {
    static func batch() -> WriteBatch {
        return base.batch()
    }
    
    static func uniqueID() -> String {
        return base.collection("0").document().documentID
    }
}
