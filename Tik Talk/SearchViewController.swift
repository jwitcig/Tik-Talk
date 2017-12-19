//
//  SearchViewController.swift
//  Tik Talk
//
//  Created by Developer on 12/15/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

let GroupCategory = 0
let UserCategory = 1

class SearchViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User]?
    var groups: [Group]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.addTarget(self, action: #selector(SearchViewController.searchTextChanged(_:)), for: .editingChanged)
    }
    
    @objc func searchTextChanged(_ sender: Any) {
        guard let searchText = searchField.text else { return }
        
        Database.Users.whose(handleStartsWith: searchText, success: {
            self.users = $0
            self.tableView.reloadData()
        }) {
            print("Error fetching users: \($0)")
        }
        
        Database.Groups.whose(nameStartsWith: searchText, success: {
            self.groups = $0
            self.tableView.reloadData()
        }) {
            print("Error fetching groups: \($0)")
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case GroupCategory:
            return groups?.count ?? 0
        case UserCategory:
            return users?.count ?? 0
        default:
            fatalError("Unimplemented section: \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell()
        
        switch indexPath.section {
        case GroupCategory:
            cell.textLabel?.text = groups?[indexPath.row].name ?? ""
        case UserCategory:
            cell.textLabel?.text = users?[indexPath.row].handle ?? ""
        default:
            fatalError("Unimplemented section: \(indexPath.section)")
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case GroupCategory:
            guard let group = groups?[indexPath.row] else { return }
            guard let user = User.currentUser else { return }
            
            let alert = UIAlertController(title: "Join \(group.name)", message: "Are you sure you would like to join \(group.name)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                Database.Groups.join(group, user: user, success: {
                    alert.dismiss(animated: true, completion: nil)
                }, failure: {
                    print("Error joining \(group.name) : \($0)")
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            
        case UserCategory:
            guard let user = users?[indexPath.row] else { return }
            guard let currentUser = User.currentUser else { return }
            
            let alert = UIAlertController(title: "Add @\(user.handle)?", message: "Are you sure you would like to add @\(user.handle) as a friend?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                Database.Users.sendFriendRequest(to: user.reference, from: currentUser, success: {
                    alert.dismiss(animated: true, completion: nil)
                }, failure: {
                    print("Error adding \(user.id) : \($0)")
                })
                
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            
        default:
            fatalError("Unimplemented section: \(indexPath.section)")
        }
    }
}
