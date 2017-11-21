//
//  Database.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

protocol ModelReference {
    var id: String { get }
}

extension DocumentReference: ModelReference {
    var id: String {
        return documentID
    }
}

class Database { }

// ***** Firebase specific *****

extension Model {
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

