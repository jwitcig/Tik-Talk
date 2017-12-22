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
        static func create(_ group: Group, success: @escaping ()->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: group).setData(group, completion: callback(success, failure))
        }
        
        static func all(success: @escaping ([Group])->(), failure: @escaping (Error)->()) {
            Firestore.collection(of: Group.self).getDocuments(completion: listCallback(success, failure))
        }
        
        static func all(containing user: UserReference, success: @escaping ([Group.Core])->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: user).collection("groups").getDocuments(completion: listCallback(success, failure))
        }
        
        static func all(createdBy user: UserReference, success: @escaping ([Group])->(), failure: @escaping (Error)->()) {
            Firestore.collection(of: Group.self)
                     .whereField("creatorID", isEqualTo: user.id)
                     .getDocuments(completion: listCallback(success, failure))
        }
        
        static func whose(nameStartsWith name: String, success: @escaping ([Group])->(), failure: @escaping (Error)->()) {            
            Firestore.collection(of: Group.self)
                     .order(by: "name")
                     .start(at: [name])
                     .end(at: [name+"z"])
                     .getDocuments(completion: listCallback(success, failure))
        }
        
        static func perform(_ action: GroupAction, on group: GroupReference, by user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {
        
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
        
        static func join(_ group: GroupReference, who user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {
            perform(.join, on: group, by: user, success: success, failure: failure)
        }
        
        static func leave(_ group: GroupReference, who user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {
            perform(.leave, on: group, by: user, success: success, failure: failure)
        }
    }
}
