//
//  MessagesViewController.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import SlackTextViewController

class MessagesViewController: SLKTextViewController {
    
    let conversation: Conversation
    var messages: [Message] = []
    
    init(conversation: Conversation) {
        self.conversation = conversation
        
        super.init(tableViewStyle: .plain)!
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("Unimplemented init(coder:)")
    }
    
    override func viewDidLoad() {
        Database.Messages.those(in: conversation, success: {
            self.messages = $0
            self.tableView?.reloadData()
        }, failure: {
            print("Error loading messages: \($0)")
        })
        
        /*
        // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
        self.registerClass(forTextView: MessageTextView.classForCoder())
        
        if DEBUG_CUSTOM_TYPING_INDICATOR == true {
            // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
            self.registerClass(forTypingIndicatorView: TypingIndicatorView.classForCoder())
        }
         */
        
        super.viewDidLoad()
        
//        self.commonInit()
        
        // SLKTVC's configuration
        self.bounces = true
        self.shakeToClearEnabled = true
        self.isKeyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.isInverted = true
        
        self.leftButton.setImage(UIImage(named: "icn_upload"), for: UIControlState())
        self.leftButton.tintColor = UIColor.gray
        
        self.rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: UIControlState())
        
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 256
        self.textInputbar.counterStyle = .split
        self.textInputbar.counterPosition = .top
        
        self.textInputbar.editorTitle.textColor = UIColor.darkGray
        self.textInputbar.editorLeftButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        self.textInputbar.editorRightButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        self.tableView?.separatorStyle = .none
        self.tableView?.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: MessageTableViewCell.messengerCellIdentifier)
        
        self.autoCompletionView.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: MessageTableViewCell.autoCompletionCellIdentifier)
        self.registerPrefixes(forAutoCompletion: ["@",  "#", ":", "+:", "/"])
        
        self.textView.placeholder = "Message";
        
        self.textView.registerMarkdownFormattingSymbol("*", withTitle: "Bold")
        self.textView.registerMarkdownFormattingSymbol("_", withTitle: "Italics")
        self.textView.registerMarkdownFormattingSymbol("~", withTitle: "Strike")
        self.textView.registerMarkdownFormattingSymbol("`", withTitle: "Code")
        self.textView.registerMarkdownFormattingSymbol("```", withTitle: "Preformatted")
        self.textView.registerMarkdownFormattingSymbol(">", withTitle: "Quote")
    }
    
    override func didPressRightButton(_ sender: Any!) {
        // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
        self.textView.refreshFirstResponder()
        
        let message = Message(creator: User.current, body: textView.text)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let rowAnimation: UITableViewRowAnimation = isInverted ? .bottom : .top
        let scrollPosition: UITableViewScrollPosition = isInverted ? .bottom : .top
        
        tableView?.beginUpdates()
        messages.insert(message, at: 0)
        tableView?.insertRows(at: [indexPath], with: rowAnimation)
        tableView?.endUpdates()
        
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        
        // Fixes the cell from blinking (because of the transform, when using translucent cells)
        tableView?.reloadRows(at: [indexPath], with: .automatic)
        
        super.didPressRightButton(sender)
        
        Database.Messages.create(message, in: conversation, success: {
            print("Message sent!")
        }, failure: {
            print("Error sending message: \($0)")
        })
    }
}

extension MessagesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return messages.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            return messageCellForRowAtIndexPath(indexPath)
        }
        fatalError()
    }
    
    func messageCellForRowAtIndexPath(_ indexPath: IndexPath) -> MessageTableViewCell {
        let cell = tableView!.dequeueReusableCell(withIdentifier: MessageTableViewCell.messengerCellIdentifier) as! MessageTableViewCell
        
        let message = messages[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = message.creatorID
        cell.bodyLabel.text = message.body
        
        cell.indexPath = indexPath
        cell.usedForMessage = true
        
        // Cells must inherit the table view's transform
        // This is very important, since the main table view may be inverted
        cell.transform = tableView!.transform
        
        return cell
    }
}

