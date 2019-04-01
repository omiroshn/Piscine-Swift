//
//  ViewController.swift
//  ex01
//
//  Created by Lesha Miroshnik on 4/1/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickMeButton(_ sender: UIButton) {
        textLabel.text = "Hello World!"
    }
    

}

