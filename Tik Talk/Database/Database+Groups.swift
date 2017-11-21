//
//  Database+Groups.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class Groups {
        typealias ModelType = Group
        typealias GroupReference = ModelReference

        static func newModel() -> GroupReference {
            return Firestore.groups.document()
        }
    
        static func create(_ group: Group, success: @escaping ()->(), failure: @escaping (Error)->()) {
            Firestore.groups.document(group.id).setData(group.dictionary) {
                guard $0 == nil  else  {
                    failure($0!)
                    return
                }
                success()
            }
        }
        
        static func all(success: @escaping ([Group])->(), failure: @escaping (Error)->()) {
            Firestore.groups.getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Group.build(from: snapshot))
            }
        }
        
        static func all(containing user: User, success: @escaping ([Group])->(), failure: @escaping (Error)->()) {
            Firestore.groups.getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Group.build(from: snapshot))
            }
        }
        
        static func all(createdBy user: User, success: @escaping ([Group])->(), failure: @escaping (Error)->()) {
            Firestore.groups.whereField("creatorID", isEqualTo: user.id).getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Group.build(from: snapshot))
            }
        }
        
        static func join(_ group: Group, user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {

            Firestore.reference(for: user).collection("groups")
                                          .document(group.id)
                                          .setData(["name" : group.name]) {
                guard $0 == nil else {
                    failure($0!)
                    return
                }
                success()
            }
        }
    }
}
