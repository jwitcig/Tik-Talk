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
