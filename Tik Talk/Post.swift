//
//  Post.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import FirebaseRemoteConfig

enum Vote {
    case up, down
}

class Post {
    let id: String
    let body: String?
    let url: String?
    let timestamp: Date
    let creatorHandle: String
    
    let metaVotes: MetaVotes
    
    var hasMultiMedia: Bool {
        return url != nil
    }
    
    var maxCharacterCount: Int {
        return hasMultiMedia ? 80 : 150
    }
    
    var charactersRemaining: Int {
        return maxCharacterCount - (body ?? "").count
    }
    
    var dictionary: [String: Any?] {
        return [
            "body": body,
            "url" : url,
            "timestamp" : timestamp.timeIntervalSince1970,
            "creatorHandle" : creatorHandle,
            "metaVotes" : [
                "upVotes" : metaVotes.upVotes,
                "downVotes" : metaVotes.downVotes,
                "takeDownTime" : metaVotes.takeDownTime.timeIntervalSince1970,
            ],
        ]
    }
    
    init(id: String, body: String?, url: String?, timestamp: Date, creatorHandle: String) {
        self.id = id
        self.body = body
        self.url = url
        self.timestamp = timestamp
        self.creatorHandle = creatorHandle
        
        let initialPostTime = RemoteConfig.remoteConfig().configValue(forKey: "InitialPostTime").numberValue?.floatValue ?? 120

        self.metaVotes = MetaVotes(postID: id,
                             takeDownTime: TimeInterval(initialPostTime))
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.body = dictionary["body"] as? String
        self.url = dictionary["url"] as? String
        self.timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as! TimeInterval)
        self.creatorHandle = dictionary["creatorHandle"] as! String
        
        self.metaVotes = MetaVotes(postID: id, dictionary: dictionary["metaVotes"] as! [String : Any])
    }

    func isValid() -> Bool {
        return charactersRemaining >= 0
    }
 }

class MetaVotes {
    let postID: String
    var upVotes: Int
    var downVotes: Int
    var takeDownTime: Date
    
    init(postID: String, takeDownTime: TimeInterval) {
        self.postID = postID
        self.upVotes = 0
        self.downVotes = 0
        self.takeDownTime = Date().addingTimeInterval(takeDownTime)
    }
    
    init(postID: String, upVotes: Int, downVotes: Int, takeDownTime: Date) {
        self.postID = postID
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.takeDownTime = takeDownTime
    }
    
    init(postID: String, dictionary: [String : Any]) {
        self.postID = postID
        self.upVotes = dictionary["upVotes"] as! Int
        self.downVotes = dictionary["downVotes"] as! Int
        self.takeDownTime = Date(timeIntervalSince1970: dictionary["takeDownTime"] as! TimeInterval)
    }
}

class PostGenerator {
    static func fakePost() -> Post {
        return Post(id: randomString(length: 64), body: randomString(length: 120), url: nil, timestamp: Date(), creatorHandle: randomString(length: 10))
    }
}
