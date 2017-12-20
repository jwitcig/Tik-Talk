//
//  SignUpViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/11/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var handleField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitPressed(sender: Any) {
        guard let handle = handleField.text else { return }
        let email = "\(handle)@tiktalk.com"
        let password = handle
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
          
            guard error == nil else {
                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                    User.currentUser = User(id: user!.uid, handle: handle, other: nil)
                    
                    Database.Users.create(User.currentUser!, success: {}, failure: {
                        print("OMG: \($0)")
                    })
                }
                return
            }
            User.currentUser = User(id: user!.uid, handle: handle, other: nil)
            
            Database.Users.create(User.currentUser!, success: {}, failure: {_ in})
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
