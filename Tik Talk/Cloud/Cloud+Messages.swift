//
//  Cloud+Messages.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Cloud {
    class Messages {                
        static func create(_ message: Message, in conversation: ConversationReference, success: @escaping ()->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: conversation)
                     .collection("messages")
                     .document(message.id)
                     .setData(message, completion: callback(success, failure))
        }
        
        static func those(in conversation: ConversationReference, success: @escaping ([Message])->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: conversation)
                     .collection("messages")
                     .getDocuments(completion: listCallback(success, failure))
        }
        
        static func listen(to conversation: ConversationReference, freshData: @escaping ([Message])->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: conversation)
                     .collection("messages")
                     .order(by: "timestamp", descending: true)
                     .addSnapshotListener(listCallback(freshData, failure))
        }
    }
}
