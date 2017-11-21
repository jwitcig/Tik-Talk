//
//  SignUpViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/11/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var handleField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitPressed(sender: Any) {
        guard let handle = handleField.text else { return }
        
        let user = User(id: Database.Users.newModel().id,
                    handle: handle,
                     other: nil)
        
        Database.Users.create(user, success: {
            
        }, failure: { error in
            print("Error: \(error)")
        })
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
