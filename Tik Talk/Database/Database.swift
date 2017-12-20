//
//  Database.swift
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

protocol ModelReference: FirestoreConstructable { }
extension ModelReference {
    init(id: String) {
        self.init(id: id, dictionary: [:])
    }
    
    init(reference: DocumentReference) {
        self.init(id: reference.documentID)
    }
}

class Database { }

