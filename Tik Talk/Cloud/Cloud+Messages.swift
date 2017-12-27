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
    class Messages<T: ConversationReference> {
        static func create(_ message: Message, in conversation: T, success: @escaping ()->(), failure: @escaping ErrorCallback) {
            Firestore.reference(for: conversation)
                     .collection("messages")
                     .document(message.id)
                     .setData(message, completion: callback(success, failure))
        }
        
        static func those(in conversation: T, success: @escaping ([Message])->(), failure: @escaping ErrorCallback) {
            Firestore.reference(for: conversation)
                     .collection("messages")
                     .getDocuments(completion: callback(success, failure))
        }
        
        static func listen(to conversation: T, freshData: @escaping ([Message])->(), failure: @escaping ErrorCallback) {
            Firestore.reference(for: conversation)
                     .collection("messages")
                     .order(by: "timestamp", descending: true)
                     .addSnapshotListener(callback(freshData, failure))
        }
    }
}
