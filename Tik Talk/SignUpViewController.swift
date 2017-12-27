//
//  SignUpViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/11/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

protocol ValidatesPasswords {
    func validate(password: String, verify: String) -> Bool
}

extension ValidatesPasswords {
    func validate(password: String, verify: String) -> Bool {
        return password == verify && password.count > 6
    }
}

class SignUpViewController: UIViewController, ValidatesPasswords {
    @IBOutlet weak var handleField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var authUser: Firebase.User?
    
    var password: String {
        return passwordField.text ?? ""
    }
    var passwordVerify: String {
        return password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().signInAnonymously {
            self.authUser = $0
            guard $1 == nil else {
                return
            }
        }
    }
    
    @IBAction func submitPressed(sender: Any) {
        guard validate(password: password, verify: passwordVerify) else { return }
        guard let authUser = self.authUser else { return }
        guard let handle = handleField.text else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: temporaryEmail(for: authUser),
                                                       password: password)
        authUser.link(with: credential) {
            guard let user = $0, $1 == nil else {
                print("Error establishing identity: \($1!)")
                return
            }
            let change = user.createProfileChangeRequest()
            change.displayName = handle
            change.commitChanges()
    
            User.current = User(id: user.uid, handle: handle, other: nil)
            
            Cloud.Users.create(User.current, success: {
                self.performSegue(withIdentifier: "ProfileUpdate", sender: self)
            }, failure: {
                print("Error saving user: \($0)")
            })
        }
    }
    
    func temporaryEmail(for user: Firebase.User) -> String {
        return "\(user.uid)@tiktalk.com"
    }
    
    @IBAction func switchToSignIn(sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
