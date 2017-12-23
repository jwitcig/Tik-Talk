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
        
        fetchAPIData()
    }
}

extension TimelineViewController {
    func fetchAPIData() {
        guard let controller = childViewControllers.first as? PostsViewController else { return }
        
        Cloud.Posts.live(success: controller.display, failure: dataFetchFailed)
    }
    
    func dataFetchFailed(error: Error) {
        
    }
}
