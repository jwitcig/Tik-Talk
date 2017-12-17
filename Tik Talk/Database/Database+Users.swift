//
//  Database+Users.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class Users {
        typealias ModelType = User
        typealias UserReference = ModelReference
        
        static func newModel() -> UserReference {
            return Firestore.users.document()
        }
        
        static func create(_ user: User, success: @escaping ()->Void, failure: @escaping (Error)->Void) {
            
            let userDoc = Firestore.users.document(user.id)
            let profileDoc = userDoc.collection("profile").document()
            
            let write = Firestore.base.batch()
            write.setData(user.dictionary, forDocument: userDoc)
            
            if let profile = user.profile {
                write.setData(profile.dictionary, forDocument: profileDoc)
            }
            
            write.commit {
                guard $0 == nil else {
                    failure($0!)
                    return
                }
                success()
            }
        }
        
        static func accountInfo(for user: User, success: @escaping (User)->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: user).getDocument {
                guard let document = $0 else {
                    failure($1!)
                    return
                }
                success(User(document: document))
            }
        }
        
        static func friends(for user: User, success: @escaping ([User])->(), failure: @escaping (Error)->()) {
            Firestore.friends(for: user).getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(User.build(from: snapshot))
            }
        }
    
        static func whose(handleStartsWith handle: String, success: @escaping ([User])->(), failure: @escaping (Error)->()) {
            Firestore.users.order(by: "handle")
                .start(at: [handle])
                .end(at: [handle+"z"])
                .getDocuments {
                    guard let snapshot = $0 else {
                        failure($1!)
                        return
                    }
                    success(User.build(from: snapshot))
            }
        }
    }
}
