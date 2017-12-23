//
//  Cloud+Conversation.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Cloud {
    class Conversations {    
        static func create(_ conversation: Conversation, success: @escaping ()->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: conversation)
                     .setData(conversation, completion: callback(success, failure))
        }
        
        static func containing(_ user: UserReference, success: @escaping ([Conversation])->(), failure: @escaping (Error)->()) {
            Firestore.conversations.whereField("participantIDs.\(user.id)", isEqualTo: true)
                                   .getDocuments(completion: callback(success, failure))
        }
    }
}
