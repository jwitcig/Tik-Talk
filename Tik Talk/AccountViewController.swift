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
        Firestore.reference(for: user).getDocument { snapshot, error in
            guard let document = snapshot else { return }
            
            let user = User(document: document)
            self.handleLabel.text = user.handle
            self.friendsButton.setTitle("\(user.friendsCount) friends", for: .normal)  
        }
        
        guard let postsViewController = childViewControllers.first as? PostsViewController else { return }
        
        Firestore.posts.whereField("creatorID", isEqualTo: user.id).getDocuments { snapshot, error in
            guard let collection = snapshot else { return }
            
            let posts = collection.documents.map { Post(document: $0) }
            
            postsViewController.display(posts: posts)
        }
    }
    
    @IBAction func friendsPressed(sender: Any) {
        guard let friendsController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController else { return }
        
        present(friendsController, animated: true, completion: nil)
    }
}
