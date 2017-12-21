//
//  PostsViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.postTableViewCellIdentifier)
    }
    
    func display(posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
}

extension PostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell")! as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.textView.text = post.body ?? ""
        
        DispatchQueue.main.async {
            do {
                let imageData = try Data(contentsOf: URL(string: "https://pbs.twimg.com/profile_images/874681555448475649/Rv_zD2l6_400x400.jpg")!)
                
                cell.profileImageView.image = UIImage(data: imageData)
            } catch { }
        }
        
        cell.voteBlock = {
            Database.Votes.cast($0, for: post, by: User.current)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let voteUp = UITableViewRowAction(style: .normal, title: "👍🏽") { action, indexPath in
            print("Vote Up")
        }
        voteUp.backgroundColor = .blue
        
        let voteDown = UITableViewRowAction(style: .normal, title: "👎🏽") { action, indexPath in
            print("Vote Down")
        }
        voteDown.backgroundColor = .red
        
        return [voteUp, voteDown]
    }
}

