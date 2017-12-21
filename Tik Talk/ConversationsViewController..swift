//
//  ConversationsViewController..swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var conversations: [Conversation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.Conversations.containing(User.current, success: {
            self.conversations = $0
            self.tableView.reloadData()
        }, failure: {
            print("Error loading conversations: \($0)")
        })
    }
    
    @IBAction func newMessagePressed(sender: Any) {
//        let messagesController = MessagesViewController()
//        present(messagesController, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        let conversation = conversations![indexPath.row]
        
        var text = conversation.participants.reduce("") {
            $0 + $1.value.name + ", "
        }
        text.removeLast()
        text.removeLast()
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = conversations?[indexPath.row] else { return }
        
        let messagesController = MessagesViewController(conversation: conversation)
        present(messagesController, animated: true, completion: nil)
    }
}

extension ConversationsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
