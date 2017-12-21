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
        
        Database.Users.accountInfo(for: User.current, success: {
            self.handleLabel.text = $0.handle
            self.friendsButton.setTitle("\($0.friendsCount) friends", for: .normal)
        }, failure: { error in
            
        })
        
        guard let postsViewController = childViewControllers.first as? PostsViewController else { return }
       
        Database.Posts.all(for: User.current, success: {
            postsViewController.display(posts: $0)
        }, failure: { error in
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Database.FriendRequests.listThose(to: User.current, success: {
            for request in $0 {
                Database.FriendRequests.accept(request, forCurrentUser: User.current.reference, success: {
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
