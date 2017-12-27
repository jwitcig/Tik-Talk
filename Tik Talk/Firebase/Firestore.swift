//
//  Firestore.swift
//  Tik Talk
//
//  Created by Developer on 11/18/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

func collectionName<T: ModelReference>(for model: T.Type) -> String {
    switch model {
    case is PostReference.Type: return "posts"
    case is UserReference.Type: return "users"
    case is GroupReference.Type: return "groups"
    case is FriendReference.Type: return "friends"
    case is FriendRequestReference.Type: return "friendRequests"
    case is ConversationReference.Type: return "conversations"
    default: fatalError()
    }
}

extension Firestore {
    static var base: Firestore {
        return Firestore.firestore()
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
