//
//  CreateGroupViewController.swift
//  Tik Talk
//
//  Created by Developer on 12/15/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, ValidatesGroups {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var model: Group { return group }
    var group: Group {
        return Group(name: nameField.text ?? "", creator: User.current)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.isEnabled = false
        
        nameField.addTarget(self, action: #selector(CreateGroupViewController.nameFieldChanged(_:)), for: .editingChanged)
    }

    @IBAction func createPressed(sender: Any) {
        guard let group = validate() else { return }
        
        Cloud.Groups.create(group, success: {
            print("Successfully created \(group.name)!")
            
            Cloud.Groups.join(group, who: User.current, success: {
                print("Successfully joined \(group.name)!")
            }, failure: {
                print("Error joining group: \($0)")
            })
            
        }, failure: {
            print("Error creating group: \($0)")
        })
    }

    @objc func nameFieldChanged(_ sender: Any) {
        createButton.isEnabled = isValid
    }
}
