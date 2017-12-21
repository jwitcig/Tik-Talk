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

protocol PostRef {
    var id: String { get }
}

struct Post: Model, PostRef {
    struct Reference: ModelReference, PostRef {
        let id: String
        let dictionary: [String : Any]
    }
    
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
            "timestamp" : timestamp,
            "creatorID" : creatorID,
            "groupID" : groupID as Any,
            "votes" : votes.dictionary,
        ]
    }
    
    init(body: String?, url: String?, timestamp: Date = Date(), creator: UserRef, group: GroupRef?) {
        self.id = Post.uniqueID()
        self.timestamp = timestamp
        self.creatorID = creator.id

        self.body = body
        self.url = url
        self.groupID = group?.id
        self.votes = Votes(postID: id,
                     takeDownTime: timestamp.addingTimeInterval(Config.initialPostTime))
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


