//
//  Post.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

enum Vote {
    case up, down
}

class Post {
    let id: String
    let body: String?
    let url: String?
    let timestamp: Date
    let creatorID: String
    
    var votes: Votes
    
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
            "creatorID" : creatorID,
            "votes": votes.dictionary
        ]
    }
    
    init(id: String, body: String?, url: String?, timestamp: Date, creatorID: String) {
        self.id = id
        self.body = body
        self.url = url
        self.timestamp = timestamp
        self.creatorID = creatorID
        
        let initialPostTime = RemoteConfig.remoteConfig().configValue(forKey: "InitialPostTime").numberValue?.floatValue ?? 120

        let takeDownTime = Date().addingTimeInterval(TimeInterval(60*initialPostTime))
        self.votes = Votes(postID: id,
                     takeDownTime: takeDownTime)
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.body = dictionary["body"] as? String
        self.url = dictionary["url"] as? String
        self.timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as! TimeInterval)
        self.creatorID = dictionary["creatorID"] as! String
       
        let votingData =  dictionary["votes"] as! [String : Any]
        self.votes = Votes(postID: id, dictionary: votingData)
    }
    
    convenience init(document: DocumentSnapshot) {
        self.init(id: document.documentID, dictionary: document.data())
    }

    func isValid() -> Bool {
        return charactersRemaining >= 0
    }
 }

class Votes {
    let postID: String
    var up: Int
    var down: Int
    var takeDownTime: Date
    
    var dictionary: [String : Any] {
        return [
            "up" : up,
            "down" : down,
            "takeDownTime" : takeDownTime.timeIntervalSince1970,
        ]
    }
    
    convenience init(postID: String, takeDownTime: Date) {
        self.init(postID: postID, up: 0, down: 0, takeDownTime: takeDownTime)
    }
    
    init(postID: String, up: Int, down: Int, takeDownTime: Date) {
        self.postID = postID
        self.up = up
        self.down = down
        self.takeDownTime = takeDownTime
    }
    
    init(postID: String, dictionary: [String : Any]) {
        self.postID = postID
        self.up = dictionary["up"] as! Int
        self.down = dictionary["down"] as! Int
        self.takeDownTime = Date(timeIntervalSince1970: dictionary["takeDownTime"] as! TimeInterval)
    }
}

class PostGenerator {
    static func fakePost() -> Post {
        return Post(id: randomString(length: 64), body: randomString(length: 120), url: nil, timestamp: Date(), creatorID: randomString(length: 10))
    }
}
