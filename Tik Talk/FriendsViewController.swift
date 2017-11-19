//
//  FriendsViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/19/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [User]?
    var filteredFriends: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = User.currentUser else { return }
        Firestore.friends(for: user).getDocuments { snapshot, error in
            guard let collection = snapshot else { return }
            let friends = collection.documents.map { User(document: $0) }
            
            self.display(friends: friends)
        }
    }
    
    func display(friends: [User]) {
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
            guard let friend = filteredFriends?[indexPath.row] else { fatalError("Could not find friend") }
            cell.textLabel?.text = friend.handle
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
        filteredFriends = filter(friends: friends, searchText: searchText)
        tableView.reloadData()
    }
    
    func filter(friends: [User], searchText: String) -> [User] {
        guard !searchText.isEmpty else { return friends }
        return friends.filter {
            $0.handle.lowercased().contains(searchText.lowercased())
        }
    }
}
