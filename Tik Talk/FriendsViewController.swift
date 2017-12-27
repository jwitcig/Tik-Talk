//
//  FriendsViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [User.Core]?
    var filteredFriends: [User.Core]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Cloud.Users.friends(for: User.current, success: display) {
            print("Error: \($0)")
        }
    }
    
    func display(friends: [User.Core]) {
        self.friends = friends
        self.filteredFriends = friends
        tableView.reloadData()
    }
    
    @IBAction func backPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return filteredFriends?.count ?? 0
        case 0:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = filteredFriends?[indexPath.row].handle
        case 1:
            break
        default:
            fatalError("Unimplemented Section: tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell")
        }
        return cell
    }
}

extension FriendsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let friends = friends else { return }
        filteredFriends = filter(friends, searchText: searchText)
        tableView.reloadData()
    }
    
    func filter(_ friends: [User.Core], searchText: String) -> [User.Core] {
        guard !searchText.isEmpty else { return friends }
        let lowercased = searchText.lowercased()
        return friends.filter {
            $0.handle.lowercased().contains(lowercased)
        }
    }
}
