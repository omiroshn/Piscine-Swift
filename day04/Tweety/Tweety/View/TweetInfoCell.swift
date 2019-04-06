//
//  TweetInfoCell.swift
//  Tweety
//
//  Created by Lesha Miroshnik on 4/6/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation
import UIKit

class TweetInfoCell : UITableViewCell {
    
    @IBOutlet weak var tweetName: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetInfo: UILabel! {
        didSet {
            tweetInfo.lineBreakMode = .byWordWrapping
            tweetInfo.numberOfLines = 0
        }
    }
    
    var tweet: Tweet! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        tweetName.text = tweet.name
        tweetInfo.text = tweet.description
        tweetDate.text = tweet.date
    }
}
