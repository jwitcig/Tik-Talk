//
//  Cloud.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

protocol FirestoreConstructable {
    var id: String { get }
    var dictionary: [String : Any] { get }
    
    init(id: String, dictionary: [String : Any])
}

extension FirestoreConstructable {
    init(document: DocumentSnapshot) {
        self.init(id: document.documentID, dictionary: document.data())
    }
    
    static func build(from documents: [DocumentSnapshot]) -> [Self] {
        return documents.map(Self.init)
    }
    
    static func build(from snapshot: QuerySnapshot) -> [Self] {
        return build(from: snapshot.documents)
    }
}

class Cloud {    
    typealias Callback = () -> Void
    typealias GetCallback<T: FirestoreConstructable> = (T) -> Void
    typealias ListCallback<T: FirestoreConstructable> = ([T]) -> Void
    typealias ErrorCallback = (Error) -> Void
    
    static func callback(_ success: @escaping ()->(), _ failure: @escaping (Error)->()) -> ((Error?)->()) {
        return {
            guard $0 == nil else  {
                failure($0!)
                return
            }
            success()
        }
    }
    
    static func callback<T: FirestoreConstructable>(_ success: @escaping (T)->(), _ failure: @escaping (Error)->()) -> FIRDocumentSnapshotBlock {
        return {
            guard $1 == nil else  {
                failure($1!)
                return
            }
            success(T(document: $0!))
        }
    }
    
    static func callback<T: FirestoreConstructable>(_ success: @escaping ([T])->(), _ failure: @escaping (Error)->()) -> FIRQuerySnapshotBlock {
        return {
            guard let snapshot = $0 else {
                failure($1!)
                return
            }
            success(T.build(from: snapshot))
        }
    }
}

extension Firestore {
    private var base: Firestore {
        return Firestore.base
    }
    
    static func collection<T: ModelReference>(of type: T.Type) -> CollectionReference {
        return base.collection(collectionName(for: type))
    }
    
    static func reference<T: ModelReference>(for reference: T) -> DocumentReference {
        return collection(of: T.self).document(reference.id)
    }
    
    static func referenceForPost(withID id: String) -> DocumentReference {
        return collection(of: Post.self).document(id)
    }
    
    static func referenceForUser(withID id: String) -> DocumentReference {
        return collection(of: User.self).document(id)
    }
    
    static func friends<T: UserReference>(for user: T) -> CollectionReference {
        return reference(for: user).collection("friends")
    }
}

extension Firestore {
    static var users: CollectionReference {
        return collection(of: User.self)
    }
    
    static var groups: CollectionReference {
        return collection(of: Group.self)
    }
    
    static var posts: CollectionReference {
        return collection(of: Post.self)
    }
    
    static var conversations: CollectionReference {
        return collection(of: Conversation.self)
    }
}

extension CollectionReference {
    func addDocument(data: FirestoreConstructable, completion: ((Error?) -> Void)? = nil) {
        addDocument(data: data.dictionary, completion: completion)
    }
}

extension DocumentReference {
    func setData(_ data: FirestoreConstructable, completion: ((Error?) -> Void)? = nil) {
        setData(data.dictionary, completion: completion)
    }
}

extension WriteBatch {
    func setData(_ data: FirestoreConstructable, forDocument document: DocumentReference) {
        setData(data.dictionary, forDocument: document)
    }
}
