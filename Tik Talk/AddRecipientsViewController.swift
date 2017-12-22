//
//  AddRecipientsViewController.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class AddRecipientsViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipientsLabel: UILabel!

    var friends: [User.Reference]?
    var filteredFriends: [User.Reference]?
    
    var recipients = Set<User.Reference>() {
        didSet {
            var text = recipients.reduce("") {
                $0 + "\($1.handle), "
            }
            text.removeLast()
            text.removeLast()
            recipientsLabel.text = text
        }
    }
    
    var resignedBlock: ((Set<User.Reference>)->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Database.Users.friends(for: User.current, success: {
            self.friends = $0
            self.tableView.reloadData()
        }, failure: {
            print("Error fetching friends: \($0)")
        })
        
        searchField.addTarget(self, action: #selector(SearchViewController.searchTextChanged(_:)), for: .editingChanged)
    }
    
    @objc func searchTextChanged(_ sender: Any) {
        guard let search = searchField.text else { return }
        
        filteredFriends = friends?.filter {
            $0.handle.starts(with: search)
        }
        tableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    @IBAction func donePressed(sender: Any) {
        recipients.insert(User.current.reference)
        resignedBlock(recipients)
    }
    
    @IBAction func cancelPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddRecipientsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension AddRecipientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let friend = filteredFriends![indexPath.row]
        cell.textLabel?.text = friend.handle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredFriends![indexPath.row]
        if recipients.contains(user) {
            recipients.remove(user)
        } else {
            recipients.insert(user)
        }
    }
}
