//
//  MessageTableViewCell.swift
//  Tik Talk
//
//  Created by Jonah Witcig on 12/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import SlackTextViewController

class MessageTableViewCell: UITableViewCell {

    static let kMessageTableViewCellMinimumHeight = 50.0
    static let kMessageTableViewCellAvatarHeight = 30.0

    static let messengerCellIdentifier = "MessengerCell"
    static let autoCompletionCellIdentifier = "AutoCompletionCell"
    
    static var defaultFontSize: CGFloat {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        return 16.0 + SLKPointSizeDifferenceForCategory(contentSizeCategory.rawValue)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: MessageTableViewCell.defaultFontSize)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: MessageTableViewCell.defaultFontSize)
        return label
    }()
    
    lazy var thumbnailView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.layer.cornerRadius = CGFloat(MessageTableViewCell.kMessageTableViewCellAvatarHeight / 2.0)
        view.layer.masksToBounds = true
        return view
    }()
    
    var indexPath: IndexPath!

    var usedForMessage: Bool!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        
        let views = [
            "thumbnailView" : thumbnailView,
            "titleLabel" : titleLabel,
            "bodyLabel" : bodyLabel,
        ] as [String : Any]
        
        let metrics = [
            "tumbSize" : MessageTableViewCell.kMessageTableViewCellAvatarHeight,
            "padding" : 15,
            "right" : 10,
            "left" : 5,
        ]
        
        var constraints = [
            "H:|-left-[thumbnailView(tumbSize)]-right-[titleLabel(>=0)]-right-|",
            "H:|-left-[thumbnailView(tumbSize)]-right-[bodyLabel(>=0)]-right-|",
            "V:|-right-[thumbnailView(tumbSize)]-(>=0)-|",
        ]
        
        if reuseIdentifier == MessageTableViewCell.messengerCellIdentifier {
            constraints.append("V:|-right-[titleLabel(20)]-left-[bodyLabel(>=0@999)]-left-|")
        } else {
            constraints.append("V:|[titleLabel]|")
        }
        
        contentView.addConstraints(constraints.flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        })
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        selectionStyle = .none
        
        let pointSize = MessageTableViewCell.defaultFontSize
        
        titleLabel.font = UIFont.systemFont(ofSize: pointSize)
        bodyLabel.font = UIFont.systemFont(ofSize: pointSize)
        
        titleLabel.text = ""
        bodyLabel.text = ""
    }
}
