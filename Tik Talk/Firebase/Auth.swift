//
//  Auth.swift
//  Tik Talk
//
//  Created by Developer on 12/26/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Firebase

extension Auth {
    var hasNonAnonymousUser: Bool {
        if let user = currentUser, !user.isAnonymous {
            return true
        }
        return false
    }
}
