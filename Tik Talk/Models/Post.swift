//
//  Post.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

enum Vote: String {
    case up, down
}

protocol PostReference: ModelReference { }

struct Post: Model, PostReference {
    struct Validator {
        let post: Post
        
        var maxCharacterCount: Int {
            return post.hasMultiMedia ? 140 : 280
        }
        
        var charactersRemaining: Int {
            return maxCharacterCount - (post.body ?? "").count
        }
        
        func validate() -> Bool {
            return charactersRemaining >= 0
        }
    }
    
    struct Core: ModelCore, PostReference {
        let id: String
        let dictionary: [String : Any]
    }
    
    let id: String
    let body: String?
    let url: String?
    let timestamp: Date
    let creatorID: String
    let groupID: String?
    
    var hasBeenValidated: Bool
    
    var votes: Votes
    
    var dictionary: [String: Any] {
        return [
            "body": body as Any,
            "url" : url as Any,
            "timestamp" : timestamp,
            "creatorID" : creatorID,
            "groupID" : groupID as Any,
            "votes" : votes.dictionary,
        ]
    }
    
    init(body: String?, url: String?, timestamp: Date = Date(), creator: UserReference, group: GroupReference?) {
        self.id = Post.uniqueID()
        self.timestamp = timestamp
        self.creatorID = creator.id

        self.body = body
        self.url = url
        self.groupID = group?.id
        self.votes = Votes(postID: id,
                     takeDownTime: timestamp.addingTimeInterval(Config.initialPostTime))
        
        self.hasBeenValidated = false
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.timestamp = dictionary["timestamp"] as! Date
        self.creatorID = dictionary["creatorID"] as! String

        self.body = dictionary["body"] as? String
        self.url = dictionary["url"] as? String
        self.groupID = dictionary["groupID"] as? String

        let votingData =  dictionary["votes"] as! [String : Any]
        self.votes = Votes(postID: id, dictionary: votingData)
        
        self.hasBeenValidated = true
    }
}

extension Post {
    var hasMultiMedia: Bool {
        return url != nil
    }
    
    var takeDownTime: Date {
        return votes.takeDownTime
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
            "takeDownTime" : takeDownTime,
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
        self.takeDownTime = dictionary["takeDownTime"] as! Date
    }
}

extension Votes {
    func count(for vote: Vote) -> Int {
        return vote == .up ? up : down
    }
}


