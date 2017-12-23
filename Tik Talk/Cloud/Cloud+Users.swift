//
//  Cloud+Users.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Cloud {
    class Users {        
        static func create(_ user: User, success: @escaping Callback, failure: @escaping ErrorCallback) {
            let write = Firestore.batch()
            write.setData(user, forDocument: Firestore.reference(for: user))
            write.commit(completion: callback(success, failure))
        }
        
        static func save(_ user: User, privateData: [String : Any]? = nil, success: @escaping Callback, failure: @escaping ErrorCallback) {
            
            let userDoc = Firestore.reference(for: user)
            let privateDoc = userDoc.collection("data").document("private")
            
            let write = Firestore.batch()
            write.setData(user, forDocument: userDoc)
            
            if let privateData = privateData {
                write.setData(privateData, forDocument: privateDoc)
            }

            write.commit(completion: callback(success, failure))
        }
        
        static func accountInfo(for user: UserReference, success: @escaping GetCallback<User>, failure: @escaping ErrorCallback) {
            Firestore.reference(for: user).getDocument(completion: callback(success, failure))
        }
        
        static func friends(for user: UserReference, success: @escaping ListCallback<User.Core>, failure: @escaping ErrorCallback) {
            Firestore.friends(for: user).getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                
                let references = snapshot.documents.map {
                    User.Core(id: $0.documentID, dictionary: $0.data()["userCore"] as! [String : Any])
                }
                success(references)
            }
        }
    
        static func whose(handleStartsWith handle: String, success: @escaping ListCallback<User>, failure: @escaping ErrorCallback) {
            Firestore.users.order(by: "handle")
                           .start(at: [handle])
                           .end(at: [handle+"z"])
                           .getDocuments(completion: callback(success, failure))
        }
    }
}
