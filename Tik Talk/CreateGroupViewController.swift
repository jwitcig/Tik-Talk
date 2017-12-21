//
//  CreateGroupViewController.swift
//  Tik Talk
//
//  Created by Developer on 12/15/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var isFormValid: Bool {
        guard let name = nameField.text else { return false }
        guard name.count >= 3 else { return false }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.isEnabled = false
        
        nameField.addTarget(self, action: #selector(CreateGroupViewController.nameFieldChanged(_:)), for: .editingChanged)
    }

    @IBAction func createPressed(sender: Any) {
        guard isFormValid else { return }
        guard let name = nameField.text else { return }
        
        let user = User.current
        let group = Group(name: name, creator: user)
        
        Database.Groups.create(group, success: {
            print("Successfully created \(name)!")
            
            Database.Groups.join(group, user: user, success: {
                print("Successfully joined \(name)!")
            }, failure: {
                print("Error joining group: \($0)")
            })
            
        }, failure: {
            print("Error creating group: \($0)")
        })
    }

    @objc func nameFieldChanged(_ sender: Any) {
        createButton.isEnabled = isFormValid
    }
}
