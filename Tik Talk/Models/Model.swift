//
//  Model.swift
//  Tik Talk
//
//  Created by Developer on 11/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Firebase

protocol Model: FirestoreConstructable {
    associatedtype Reference: ModelReference

    var id: String { get }
}

extension Model {
    var reference: Reference {
        return Reference(id: id, dictionary: dictionary)
    }
    
    static func uniqueID() -> String {
        return Firestore.uniqueID()
    }
}

protocol ModelReference: FirestoreConstructable {
    var id: String { get }
}
extension ModelReference {
    init(id: String) {
        self.init(id: id, dictionary: [:])
    }
    
    init(reference: DocumentReference) {
        self.init(id: reference.documentID)
    }
}
