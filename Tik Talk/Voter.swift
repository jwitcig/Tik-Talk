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
        
        Database.referenceForMetaVotes(for: post).runTransactionBlock({ currentData in
            
            guard var metaVotes = currentData.value as? [String : Any] else {
                return TransactionResult.success(withValue: currentData)
            }
            
            let voteKey = vote == .up ? "upVotes" : "downVotes"
            
            let votes = metaVotes[voteKey] as? Int ?? -1
            
//            let lastKnownVotes = vote == .up ? post.metaVotes.upVotes : post.metaVotes.downVotes
           
            metaVotes[voteKey] = votes + 1
            
            currentData.value = metaVotes
            
            return TransactionResult.success(withValue: currentData)
        }) { error, success, snapshot in
            guard error == nil else { return }
            
            
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
