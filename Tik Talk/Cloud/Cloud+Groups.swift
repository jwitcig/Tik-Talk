//
//  Cloud+Groups.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

enum GroupAction {
    case join, leave
}

extension Cloud {
    class Groups {    
        static func create(_ group: Group, success: @escaping ()->(), failure: @escaping ErrorCallback) {
            Firestore.reference(for: group).setData(group, completion: callback(success, failure))
        }
        
        static func all(success: @escaping ([Group])->(), failure: @escaping ErrorCallback) {
            Firestore.groups.getDocuments(completion: callback(success, failure))
        }
        
        static func all<U: UserReference>(containing user: U, success: @escaping ([Group.Core])->(), failure: @escaping ErrorCallback) {
            Firestore.reference(for: user).collection("groups").getDocuments(completion: callback(success, failure))
        }
        
        static func all<U: UserReference>(createdBy user: U, success: @escaping ([Group])->(), failure: @escaping ErrorCallback) {
            Firestore.groups.whereField("creatorID", isEqualTo: user.id)
                            .getDocuments(completion: callback(success, failure))
        }
        
        static func whose(nameStartsWith name: String, success: @escaping ([Group])->(), failure: @escaping ErrorCallback) {
            Firestore.groups.order(by: "name")
                            .start(at: [name])
                            .end(at: [name+"z"])
                            .getDocuments(completion: callback(success, failure))
        }
        
        static func perform<G: GroupReference>(_ action: GroupAction, on group: G, by user: User, success: @escaping ()->(), failure: @escaping ErrorCallback) {
        
            let associationRef = Firestore.reference(for: user).collection("groups").document(group.id)
            let groupRef = Firestore.reference(for: group)
            let memberRef = groupRef.collection("members").document(user.id)
            
            Firestore.base.runTransaction({ transaction, errorPointer in
                let groupDoc: DocumentSnapshot
                do {
                    groupDoc = try transaction.getDocument(groupRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                let group = Group(document: groupDoc)
                
                switch action {
                case .join:
                    transaction.updateData([
                        "memberCount" : group.memberCount + 1,
                    ], forDocument: groupRef)

                    transaction.setData([
                        "handle" : user.handle,
                        "joinDate" : Date(),
                    ], forDocument: memberRef)
                    
                    transaction.setData([
                        "name" : group.name,
                        "joinDate" : Date(),
                    ], forDocument: associationRef)
                case .leave:
                    transaction.updateData([
                        "memberCount" : group.memberCount - 1,
                    ], forDocument: groupRef)
                    transaction.deleteDocument(memberRef)
                    transaction.deleteDocument(associationRef)
                }
                return nil
            }) { object, error in
                guard error == nil else {
                    failure(error!)
                    return
                }
                success()
            }
        }
        
        static func join<G: GroupReference>(_ group: G, who user: User, success: @escaping ()->(), failure: @escaping ErrorCallback) {
            perform(.join, on: group, by: user, success: success, failure: failure)
        }
        
        static func leave<G: GroupReference>(_ group: G, who user: User, success: @escaping ()->(), failure: @escaping ErrorCallback) {
            perform(.leave, on: group, by: user, success: success, failure: failure)
        }
    }
}
