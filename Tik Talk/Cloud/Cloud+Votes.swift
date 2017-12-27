//
//  Cloud+Votes.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase
import FirebaseDatabase

extension Cloud {    
    class Votes {
        static func cast(_ vote: Vote, for post: Post, by user: User) {
            let postRef = Firestore.reference(for: post)
            let voterDocRef = postRef.collection("voters").document(user.id)
            Firestore.base.runTransaction({ transaction, errorPointer in
                let postDocument: DocumentSnapshot
                do {
                    postDocument = try transaction.getDocument(postRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                let serverPost = Post(document: postDocument)
            
                let adjustment = Config.adjustment(for: vote)
                let newTakeDownTime = serverPost.takeDownTime.addingTimeInterval(adjustment)
                
                let newVoteCount = serverPost.votes.count(for: vote) + 1
                
                transaction.updateData([
                    "votes."+vote.rawValue : newVoteCount,
                    "votes.takeDownTime" : newTakeDownTime.utc,
                ], forDocument: postRef)
                transaction.setData(["vote" : vote.rawValue], forDocument: voterDocRef)
               
                return newVoteCount
            }) { object, error in
                
            }
        }
    }
}
