//
//  AppDelegate.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        RemoteConfig.remoteConfig().fetch { status, error in
            RemoteConfig.remoteConfig().activateFetched()
        }
        
        let handle = "jwitcig"
        let email = "\(handle)@tiktalk.com"
        let password = handle
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            guard error == nil else {
                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                    User.currentUser = User(id: user!.uid, handle: handle, other: nil)
                    
                    let profile = Profile(bio: "my name is jonah", birthday: "12/30/1996", friendsCount: 0)
                    User.currentUser?.profile = profile
                    Database.Users.create(User.currentUser!, success: {}, failure: {
                        print("OMG: \($0)")
                    })
                }
                return
            }
            
            User.currentUser = User(id: user!.uid, handle: handle, other: nil)

            let profile = Profile(bio: "my name is jonah", birthday: "12/30/1996", friendsCount: 0)
            User.currentUser?.profile = profile
            Database.Users.create(User.currentUser!, success: {}, failure: {_ in})
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

