//
//  Database+Conversation.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class Conversations {
        typealias ModelType = Conversation
    
        static func create(_ conversation: Conversation, success: @escaping ()->(), failure: @escaping (Error)->()) {
            
            Firestore.reference(for: conversation).setData(conversation) {
                guard $0 == nil  else  {
                    failure($0!)
                    return
                }
                success()
            }
        }
        
        static func containing(_ user: UserRef, success: @escaping ([Conversation])->(), failure: @escaping (Error)->()) {
            Firestore.conversations.whereField("participantIDs.\(user.id)", isEqualTo: true).getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Conversation.build(from: snapshot))
            }
        }
    }
}
