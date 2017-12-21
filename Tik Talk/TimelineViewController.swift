//
//  FirstViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let postsViewController = childViewControllers.first as? PostsViewController else { return }
       
        Database.Posts.live(success: postsViewController.display, failure: { error in
            
        })
    }
}
