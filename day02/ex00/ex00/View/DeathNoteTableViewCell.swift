//
//  DeathNoteTableViewCell.swift
//  ex00
//
//  Created by Lesha Miroshnik on 4/4/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation
import UIKit

class DeathNoteTableViewCell : UITableViewCell {
    
    @IBOutlet weak var deathName: UILabel!
    @IBOutlet weak var deathTime: UILabel!
    @IBOutlet weak var deathInfo: UILabel! {
        didSet {
            deathInfo.lineBreakMode = .byWordWrapping
            deathInfo.numberOfLines = 0
        }
    }
    
    var dead: Data! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        deathName.text = dead.name
        deathInfo.text = dead.description
        deathTime.text = dead.deathTime
    }
}
