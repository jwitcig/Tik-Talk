//
//  Database+Groups.swift
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

extension Database {
    class Groups {
        typealias ModelType = Group

        static func newModel() -> Group.Reference {
            return Group.Reference(reference: Firestore.groups.document())
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
        
        static func all(containing user: User, success: @escaping ([Group.Reference])->(), failure: @escaping (Error)->()) {
            Firestore.reference(for: user).collection("groups").getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Group.Reference.build(from: snapshot))
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
        
        static func whose(nameStartsWith name: String, success: @escaping ([Group])->(), failure: @escaping (Error)->()) {            
            Firestore.groups.order(by: "name")
                            .start(at: [name])
                            .end(at: [name+"z"])
                            .getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Group.build(from: snapshot))
            }
        }
        
        static func perform(_ action: GroupAction, on group: Group, by user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {
        
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
                        "joinDate" : Date().utc,
                    ], forDocument: memberRef)
                    
                    transaction.setData([
                        "name" : group.name,
                        "joinDate" : Date().utc,
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
        
        static func join(_ group: Group, user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {
            perform(.join, on: group, by: user, success: success, failure: failure)
        }
        
        static func leave(_ group: Group, user: User, success: @escaping ()->(), failure: @escaping (Error)->()) {
            perform(.leave, on: group, by: user, success: success, failure: failure)
        }
    }
}
