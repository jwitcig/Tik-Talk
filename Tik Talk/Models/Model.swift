//
//  Model.swift
//  Tik Talk
//
//  Created by Developer on 11/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Firebase

protocol Model: FirestoreConstructable, Hashable {
    associatedtype Core: ModelCore

    var id: String { get }
}

extension Model {
    var core: Core {
        return Core(id: id, dictionary: dictionary)
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

protocol ModelCore: FirestoreConstructable, Hashable {
    var id: String { get }
}

extension ModelCore {
    init(id: String) {
        self.init(id: id, dictionary: [:])
    }
    
    init(reference: DocumentReference) {
        self.init(id: reference.documentID)
    }
}

extension ModelCore {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==<T: ModelCore>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}

protocol ModelReference {
    var id: String { get }
}
