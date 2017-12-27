//
//  AccountViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/18/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

class AccountViewController: UIViewController {

    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var friendsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleLabel.text = User.current.handle
    
        Cloud.Users.accountInfo(for: User.current, success: {
            self.friendsButton.setTitle("\($0.friendsCount) friends", for: .normal)
        }, failure: {
            print("Error fetching user information: \($0)")
        })
        
        guard let postsController = childViewControllers.first as? PostsViewController else { return }
       
        Cloud.Posts.all(for: User.current, success: postsController.display, failure: { error in
            
        })
    }
    
    @IBAction func signOutPressed(sender: Any) {
        do {
            try Auth.auth().signOut()
            tabBarController?.dismiss(animated: true, completion: nil)
        } catch let error  {
            print("Error signing out: \(error)")
        }
    }
    
    @IBAction func friendsPressed(sender: Any) {
        guard let friendsController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController else { return }
        
        present(friendsController, animated: true, completion: nil)
    }
}
