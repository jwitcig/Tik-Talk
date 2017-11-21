//
//  Storage.swift
//  Tik Talk
//
//  Created by Developer on 11/12/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Storage {
    static var base: StorageReference {
        return Storage.storage().reference()
    }
    
    static var posts: StorageReference {
        return base.child("posts")
    }
  
    static func post(withID id: String) -> StorageReference {
        return posts.child(id)
    }
}
