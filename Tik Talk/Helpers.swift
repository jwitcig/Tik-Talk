//
//  Helpers.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

func randomString(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let length = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let random = arc4random_uniform(length)
        var nextCharacter = letters.character(at: Int(random))
        randomString += NSString(characters: &nextCharacter, length: 1) as String
    }
    return randomString
}

extension DateFormatter {
    static var utc: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
}

extension Date {
    init(utc: String) {
        self.init(timeInterval: 0, since: DateFormatter.utc.date(from: utc)!)
    }
    
    var utc: String {
        return DateFormatter.utc.string(from: self)
    }
}

extension UIStoryboard {
    convenience init(name: String, bundle: Bundle? = nil) {
        self.init(name: name, bundle: nil)
    }
}

extension Auth {
    var hasNonAnonymousUser: Bool {
        if let user = currentUser, !user.isAnonymous {
            return true
        }
        return false
    }
}
