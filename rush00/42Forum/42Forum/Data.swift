//
//  Data.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation

struct Topic : CustomStringConvertible {
    var description: String {
        return "Id: \(self.topicId), Login: \(self.login), Name: \(self.topicName), Date: \(self.topicDate)"
    }
    var topicId: Int
    var login: String
    var topicName: String
    var topicDate: String
}

struct Reply : CustomStringConvertible {
    var description: String {
        return "Login: \(self.login), Content: \(self.content), Date: \(date)"
    }
    var login:  String
    var content:    String
    var date:    String
}

struct TopicMessage : CustomStringConvertible {
    var description: String {
        return "Login: \(self.login), Content: \(self.content), Date: \(date)"
    }
    var login:  String
    var content:    String
    var date:    String
    var replies: [Reply]
}
