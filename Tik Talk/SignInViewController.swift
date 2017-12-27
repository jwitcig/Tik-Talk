//
//  SignInViewController.swift
//  Tik Talk
//
//  Created by Developer on 12/23/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var email: String {
        return emailField.text ?? ""
    }
    
    var password: String {
        return passwordField.text ?? ""
    }
    
    @IBAction func signInPressed(sender: Any) {
        Auth.auth().signIn(withEmail: email, password: password) {
            guard let authUser = $0, $1 == nil else {
                print("Error signging in: \($1!)")
                return
            }
            let userRef = User.Core(id: authUser.uid)
            Cloud.Users.accountInfo(for: userRef, success: {
                User.current = $0
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let controller = storyboard.instantiateInitialViewController() else { return }
                self.present(controller, animated: true, completion: nil)
            }, failure: {
                print("Error fetching account info: \($0)")
            })
        }
    }
}
