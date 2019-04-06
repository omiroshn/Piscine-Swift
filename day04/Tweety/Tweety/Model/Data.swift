//
//  Data.swift
//  Tweety
//
//  Created by Lesha Miroshnik on 4/5/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

struct Tweet: CustomStringConvertible {
    let name: String
    let text: String
    let date: String
    var description: String {
        return "(\(name), \(text)), \(date))"
    }
}
