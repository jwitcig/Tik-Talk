//
//  PostTableViewCell.swift
//  Tik Talk
//
//  Created by Developer on 11/13/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var voteUpButton: UIButton!
    @IBOutlet weak var voteDownButton: UIButton!
    
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageStackViewHeightConstraint: NSLayoutConstraint!
    private var imageStackViewHeightConstraintConstant: CGFloat = 0
    
    var voteBlock: ((Vote)->())?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageStackViewHeightConstraintConstant = imageStackViewHeightConstraint.constant
        imageStackViewHeightConstraint.constant = 0
    }
    
    func add(images: [UIImage]) {
        imageStackViewHeightConstraint.constant = imageStackViewHeightConstraintConstant
        
        imageStackView.addArrangedSubviews(images.map(UIImageView.init))
    }
    
    @IBAction func vote(sender: UIButton) {
        voteBlock?(sender == voteUpButton ? .up : .down)
    }
}
