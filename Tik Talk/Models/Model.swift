//
//  Model.swift
//  Tik Talk
//
//  Created by Developer on 11/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Firebase

protocol Model: FirestoreConstructable, Hashable {
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

extension Model {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==<T: Model>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}

protocol ModelReference: FirestoreConstructable, Hashable {
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

extension ModelReference {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==<T: ModelReference>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
