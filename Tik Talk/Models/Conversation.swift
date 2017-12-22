//
//  Conversation.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

protocol ConversationReference: ModelReference { }

struct Conversation: Model, ConversationReference {
    struct Core: ModelCore, ConversationReference {
        let id: String
        let dictionary: [String : Any]
    }
    
    let id: String
    let timestamp: Date
    
    let participants: [String : User.Core]
   
    var isEstablished: Bool
    
    var dictionary: [String : Any] {
        return [
            "timestamp" : timestamp,
            "participants" : participants.reduce(into: [:]) {$0[$1.key] = $1.value.dictionary},
            "participantIDs" : participants.reduce(into: [:]) {$0[$1.key] = true},
        ]
    }
    
    init(participants: [User.Core], group: GroupReference? = nil) {
        self.id = group?.id ?? Conversation.uniqueID()
        self.timestamp = Date()

        self.participants = participants.reduce(into: [:]) { $0[$1.id] = $1 }
        
        self.isEstablished = false
    }
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.timestamp = dictionary["timestamp"] as! Date

        let participantData = dictionary["participants"] as! [String : [String : Any]]
        self.participants = participantData.reduce(into: [:]) {
            $0[$1.key] = User.Core(id: $1.key, dictionary: $1.value)
        }
        
        self.isEstablished = true
    }
}
