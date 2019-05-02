//
//  PasswordViewController.swift
//  Diary
//
//  Created by Lesha Miroshnik on 4/13/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    let aPassword = "admin"
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard let password = passwordTextField.text else {return}
        if password == self.aPassword {
            self.performSegue(withIdentifier: "toTableFromPassword", sender: self)
        } else {
            let title = NSLocalizedString("Error", comment: "")
            let msg = NSLocalizedString("Wrong password", comment: "")
            self.showAlert(withTitle: title, withMessage: msg)
        }
    }

}
