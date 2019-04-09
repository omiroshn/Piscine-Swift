//
//  TableViewCell.swift
//  MapsAndLocations
//
//  Created by Lesha Miroshnik on 4/9/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var place: Place? {
        didSet {
            myImage.image = self.place?.image
            labelText.text = self.place?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    
    func setPlace(withPlace place: Place) {
        self.place = place
    }
    
}
