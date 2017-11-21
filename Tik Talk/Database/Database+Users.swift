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
            Firestore.users.document(user.id).setData(user.dictionary) {
                guard $0 == nil  else  {
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
    }
}
