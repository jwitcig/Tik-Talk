//
//  Configuration.swift
//  Tik Talk
//
//  Created by Developer on 11/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

struct Config {
    private static let remoteConfig = RemoteConfig.remoteConfig()
    
    static var initialPostTime: TimeInterval {        
        return (remoteConfig.configValue(forKey: "InitialPostTime").numberValue?.doubleValue ?? 120) * 60
    }

    static func adjustment(for vote: Vote) -> TimeInterval {
        return (vote == .up ? 30 : -15) * 60
    }
}

struct Constants {
    static let postTableViewCellIdentifier = "PostTableViewCell"
}

