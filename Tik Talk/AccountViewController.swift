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

        guard let user = User.currentUser else { return }
        
        Database.Users.accountInfo(for: user, success: {
            self.handleLabel.text = $0.handle
            self.friendsButton.setTitle("\($0.friendsCount) friends", for: .normal)
        }, failure: { error in
            
        })
        
        guard let postsViewController = childViewControllers.first as? PostsViewController else { return }
       
        Database.Posts.all(for: user, success: {
            postsViewController.display(posts: $0)
        }, failure: { error in
            
        })
    }
    
    @IBAction func friendsPressed(sender: Any) {
        guard let friendsController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController else { return }
        
        present(friendsController, animated: true, completion: nil)
    }
}
