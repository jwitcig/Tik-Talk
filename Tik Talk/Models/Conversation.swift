//
//  Conversation.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol ConversationRef {
    var id: String { get }
}

struct Conversation: Model, ConversationRef {
    struct Reference: ModelReference, ConversationRef {
        let id: String
        let dictionary: [String : Any]
    }
    
    let id: String
    
    let participants: [String : User.Reference]
    
    let timestamp: Date
    
    var dictionary: [String : Any] {
        return [
            "timestamp" : timestamp,
            "participants" : participants.reduce(into: [:]) {$0[$1.key] = $1.value.dictionary},
        ]
    }
    
    init(participants: [User.Reference], group: GroupRef? = nil) {
        self.id = group?.id ?? Conversation.uniqueID()
        self.participants = participants.reduce(into: [:]) { $0[$1.id] = $1 }
        self.timestamp = Date()
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        
        let participantData = dictionary["participants"] as! [String : [String : Any]]
        self.participants = participantData.reduce(into: [:]) {
            $0[$1.key] = User.Reference(id: $1.key, dictionary: $1.value)
        }
        self.timestamp = dictionary["timestamp"] as! Date
    }
}
