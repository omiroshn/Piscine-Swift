//
//  APITwitterDelegate.swift
//  Tweety
//
//  Created by Lesha Miroshnik on 4/5/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class {
    
    func processTweets(tweetsArray tweets: [Tweet])
    func error(withError error: Error)
    
}
