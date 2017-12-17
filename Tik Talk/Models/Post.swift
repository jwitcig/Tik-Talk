//
//  Post.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

enum Vote: String {
    case up, down
}

struct Post: Model {
    let id: String
    let body: String?
    let url: String?
    let timestamp: Date
    let creatorID: String
    let groupID: String?
    
    var votes: Votes
    
    var dictionary: [String: Any] {
        return [
            "body": body as Any,
            "url" : url as Any,
            "timestamp" : timestamp.utc,
            "creatorID" : creatorID,
            "groupID" : groupID as Any,
            "votes" : votes.dictionary,
        ]
    }
    
    init(id: String, body: String?, url: String?, timestamp: Date = Date(), creatorID: String, groupID: String?) {
        self.id = id
        self.body = body
        self.url = url
        self.timestamp = timestamp
        self.creatorID = creatorID
        self.groupID = groupID
        self.votes = Votes(postID: id,
                     takeDownTime: timestamp.addingTimeInterval(Config.initialPostTime))
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.body = dictionary["body"] as? String
        self.url = dictionary["url"] as? String
        self.timestamp = Date(utc: dictionary["timestamp"] as! String)
        self.creatorID = dictionary["creatorID"] as! String
        self.groupID = dictionary["groupID"] as? String

        let votingData =  dictionary["votes"] as! [String : Any]
        self.votes = Votes(postID: id, dictionary: votingData)
    }
}

extension Post {
    var hasMultiMedia: Bool {
        return url != nil
    }
    
    var maxCharacterCount: Int {
        return hasMultiMedia ? 80 : 150
    }
    
    var charactersRemaining: Int {
        return maxCharacterCount - (body ?? "").count
    }
    
    var takeDownTime: Date {
        return votes.takeDownTime
    }
    
    func isValid() -> Bool {
        return charactersRemaining >= 0
    }
}

extension Post {
    class Generator {
        static func fake() -> Post {
            return Post(id: randomString(length: 64), body: randomString(length: 120), url: nil, timestamp: Date(), creatorID: randomString(length: 10), groupID: nil)
        }
    }
}

struct Votes {
    let postID: String
    var up: Int
    var down: Int
    var takeDownTime: Date
    
    var dictionary: [String : Any] {
        return [
            "up" : up,
            "down" : down,
            "takeDownTime" : takeDownTime.utc,
        ]
    }
    
    init(postID: String, up: Int = 0, down: Int = 0, takeDownTime: Date) {
        self.postID = postID
        self.up = up
        self.down = down
        self.takeDownTime = takeDownTime
    }
    
    init(postID: String, dictionary: [String : Any]) {
        self.postID = postID
        self.up = dictionary["up"] as! Int
        self.down = dictionary["down"] as! Int
        self.takeDownTime = Date(utc: dictionary["takeDownTime"] as! String)
    }
}

extension Votes {
    func count(for vote: Vote) -> Int {
        return vote == .up ? up : down
    }
}


