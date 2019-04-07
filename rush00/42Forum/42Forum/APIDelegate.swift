//
//  APIDelegate.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation

protocol APIDelegate : class {
    func receiveTopics(topicsArray topics: [Topic])
    func receiveMessages(messagesArray messages: [TopicMessage])
}
