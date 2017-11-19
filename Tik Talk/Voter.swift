//
//  Voter.swift
//  Tik Talk
//
//  Created by Developer on 11/16/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

class Voter {
    
    static func cast(vote: Vote, for post: Post) {
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
    
//    func vote(_ vote: Vote) {
//        let takeDownBump: TimeInterval
//        switch vote {
//        case .up:
//            let upVoteAdditionTime = RemoteConfig.remoteConfig().configValue(forKey: "UpVoteAdditionTime").numberValue?.floatValue ?? 5
//
//            metaVotes.upVotes += 1
//            takeDownBump = TimeInterval(upVoteAdditionTime) // 30 min
//        case .down:
//            let downVoteSubtractionTime = RemoteConfig.remoteConfig().configValue(forKey: "DownVoteSubtractionTime").numberValue?.floatValue ?? 5
//
//            metaVotes.downVotes += 1
//            takeDownBump = TimeInterval(-downVoteSubtractionTime) // -15 min
//        }
//
//        // time interval (in minutes) * 60 seconds
//        metaVotes.takeDownTime = metaVotes.takeDownTime.addingTimeInterval(takeDownBump * 60)
//    }
    
}
