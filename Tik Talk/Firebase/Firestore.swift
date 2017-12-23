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
    static func batch() -> WriteBatch {
        return base.batch()
    }
    
    static func uniqueID() -> String {
        return base.collection("0").document().documentID
    }
}
