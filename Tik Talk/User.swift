//
//  User.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class User {
    static var currentUser: User?
    
    let id: String
    let handle: String
    
    var dictionary: [String : Any] {
        return [
            "handle" : handle
        ]
    }
    
    init(id: String, handle: String) {
        self.id = id
        self.handle = handle
    }
}
