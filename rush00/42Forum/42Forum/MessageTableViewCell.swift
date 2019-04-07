//
//  MessageTableViewCell.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var topicMessageData: TopicMessage! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        loginLabel.text = topicMessageData.login
        dateLabel.text = topicMessageData.date
        contentLabel.text = topicMessageData.content
    }
    
    var topicMessageDataReply: Reply! {
        didSet {
            updateUIReply()
        }
    }
    
    func updateUIReply() {
        loginLabel.text = topicMessageDataReply.login
        dateLabel.text = topicMessageDataReply.date
        contentLabel.text = topicMessageDataReply.content
    }

}
