//
//  Database+Messages.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class Messages {
        typealias ModelType = Message
        
        static func create(_ message: Message, in conversation: ConversationRef, success: @escaping ()->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: conversation).collection("messages").document(message.id).setData(message) {
                guard $0 == nil  else  {
                    failure($0!)
                    return
                }
                success()
            }
        }
        
        static func those(in conversation: ConversationRef, success: @escaping ([Message])->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: conversation).collection("messages").getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Message.build(from: snapshot))
            }
        }
    }
}
