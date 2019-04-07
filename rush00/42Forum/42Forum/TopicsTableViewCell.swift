//
//  TopicsTableViewCell.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topicName: UILabel! {
        didSet {
            topicName.lineBreakMode = .byWordWrapping
            topicName.numberOfLines = 0
        }
    }
    @IBOutlet weak var topicLogin: UILabel!
    @IBOutlet weak var topicCreationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var topicData: Topic! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        topicName.text = topicData.topicName
        topicLogin.text = topicData.login
        topicCreationDate.text = topicData.topicDate
    }

}
