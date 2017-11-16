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
        
        let ref = Database.users.childByAutoId()
    
        let user = User(id: ref.key, handle: handle)
        
        ref.setValue(user.dictionary)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
