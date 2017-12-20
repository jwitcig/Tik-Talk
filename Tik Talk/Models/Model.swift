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
}

extension Model {
    var reference: Reference {
        return Reference(id: id, dictionary: dictionary)
    }
    
    static func uniqueID() -> String {
        return Firestore.uniqueID()
    }
}
