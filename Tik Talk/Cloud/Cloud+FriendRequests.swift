//
//  Cloud+FriendRequests.swift
//  Tik Talk
//
//  Created by Developer on 12/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Cloud {
    class FriendRequests {
        static func create(pair requests: (FriendRequest, FriendRequest), success: @escaping ()->(), failure: @escaping (Error)->()) {
            
            guard requests.0.isRecipient != requests.1.isRecipient else {
                return
            }
            guard requests.0.id != requests.1.id else {
                return
            }
            
            let copy1 = Firestore.referenceForUser(withID: requests.1.id)
                                 .collection("friendRequests")
                                 .document(requests.0.id)
            let copy2 = Firestore.referenceForUser(withID: requests.0.id)
                                 .collection("friendRequests")
                                 .document(requests.1.id)

            
            let write = Firestore.batch()
            write.setData(requests.0, forDocument: copy1)
            write.setData(requests.1, forDocument: copy2)
            write.commit(completion: callback(success, failure))
        }
        
        static func listThose<U: UserReference>(to recipient: U, success: @escaping ([FriendRequest])->(), failure: @escaping ErrorCallback) {
            listThose(with: recipient, as: .recipient, success: success, failure: failure)
        }
        
        static func listThose<U: UserReference>(from sender: U, success: @escaping ([FriendRequest])->(), failure: @escaping (Error)->()) {
            listThose(with: sender, as: .sender, success: success, failure: failure)
        }
        
        private static func listThose<U: UserReference>(with user: U, as target: FriendRequest.Target, success: @escaping ([FriendRequest])->(), failure: @escaping ErrorCallback) {
            
            Firestore.reference(for: user)
                     .collection("friendRequests")
                     .whereField("isRecipient", isEqualTo: target != .recipient)
                     .getDocuments(completion: callback(success, failure))
        }
        
        static func accept(_ request: FriendRequest, currentUser: User.Core, success: @escaping Callback, failure: @escaping ErrorCallback) {
        
            let UserReference = Firestore.reference(for: request.userCore)
            let currentUserReference = Firestore.reference(for: currentUser)
            
            let copy1 = currentUserReference.collection("friends").document(request.userCore.id)
            let copy2 = UserReference.collection("friends").document(currentUser.id)
           
            let request1 = UserReference.collection("friendRequests").document(currentUser.id)
            let request2 = currentUserReference.collection("friendRequests").document(request.userCore.id)
            
            let write = Firestore.batch()
            write.setData(Friend(user: request.userCore), forDocument: copy1)
            write.setData(Friend(user: currentUser), forDocument: copy2)
            write.deleteDocument(request1)
            write.deleteDocument(request2)
            
            write.commit(completion: callback(success, failure))
        }
    }
}
