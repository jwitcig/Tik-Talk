//
//  Database+Votes.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class Votes {
        static func cast(_ vote: Vote, for post: Post) {
            let postRef = Firestore.reference(for: post)
            let voterDocRef = postRef.collection("voters").document(User.currentUser!.id)
            Firestore.base.runTransaction({ transaction, errorPointer in
                let postDocument: DocumentSnapshot
                do {
                    postDocument = try transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                let serverPost = Post(id: postDocument.documentID, dictionary: postDocument.data())
                
                let key = vote == .up ? "up" : "down"
                let serverVoteCount = vote == .up ? serverPost.votes.up : serverPost.votes.down
                
                let adjustmentInterval: TimeInterval = vote == .up ? 30 : -15
                let newTakeDownTime = serverPost.votes.takeDownTime.addingTimeInterval(60*adjustmentInterval).timeIntervalSince1970
                
                let newVoteCount = serverVoteCount + 1
                let votes: [String : Any] = [
                    "votes."+key : newVoteCount,
                    "votes.takeDownTime" : newTakeDownTime,
                    ]
                transaction.updateData(votes, forDocument: postRef)
                transaction.setData(["vote" : key], forDocument: voterDocRef)
                return newVoteCount
            }) { object, error in
                
            }
        }
    }
}
