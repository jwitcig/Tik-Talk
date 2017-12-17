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
}
