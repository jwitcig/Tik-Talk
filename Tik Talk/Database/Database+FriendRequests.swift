//
//  Database+FriendRequests.swift
//  Tik Talk
//
//  Created by Developer on 12/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class FriendRequests {
        static func new(senderID: String, recipientID: String) -> FriendRequestRef {
            return FriendRequest.Reference(reference: Firestore.friendRequests.document("sender:\(senderID)-recipientID:\(recipientID)"))
        }
        
        static func create(pair requests: (FriendRequest, FriendRequest), success: @escaping ()->(), failure: @escaping (Error)->()) {
            
            guard requests.0.isRecipient != requests.1.isRecipient else {
                return
            }
            guard requests.0.id != requests.1.id else {
                return
            }
            
            let copy1 = Firestore.referenceForUser(withID: requests.1.id).collection("friendRequests").document(requests.0.id)
            let copy2 = Firestore.referenceForUser(withID: requests.0.id).collection("friendRequests").document(requests.1.id)

            
            let write = Firestore.base.batch()
            write.setData(requests.0.dictionary, forDocument: copy1)
            write.setData(requests.1.dictionary, forDocument: copy2)
            write.commit {
                guard $0 == nil else {
                    failure($0!)
                    return
                }
                success()
            }
        }
        
        static func listThose(to recipient: UserRef, success: @escaping ([FriendRequest])->(), failure: @escaping (Error)->()) {
            listThose(with: recipient, as: .recipient, success: success, failure: failure)
        }
        
        static func listThose(from sender: UserRef, success: @escaping ([FriendRequest])->(), failure: @escaping (Error)->()) {
            listThose(with: sender, as: .sender, success: success, failure: failure)
        }
        
        private static func listThose(with user: UserRef, as target: FriendRequest.Target, success: @escaping ([FriendRequest])->(), failure: @escaping (Error)->()) {
            
            Firestore.reference(for: user).collection("friendRequests")
                .whereField("isRecipient", isEqualTo: target != .recipient)
                .getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(FriendRequest.build(from: snapshot))
            } 
        }
        
        static func accept(_ request: FriendRequest, success: @escaping ()->(), failure: @escaping (Error)->()) {
            
            
            
        }
    }
}
