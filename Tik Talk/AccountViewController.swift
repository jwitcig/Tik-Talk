//
//  AccountViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/18/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let user = User.current
        Cloud.FriendRequests.listThose(to: user, success: {
            for request in $0 {
                Cloud.FriendRequests.accept(request, currentUser: user.core, success: {
                    print("Friends!")
                }, failure: {
                    print("Error creating friendship: \($0)")
                })
            }
        }, failure: {
            print("Error fetching friend requests: \($0)")
        })
    }
    
    @IBAction func friendsPressed(sender: Any) {
        guard let friendsController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController else { return }
        
        present(friendsController, animated: true, completion: nil)
    }
}
