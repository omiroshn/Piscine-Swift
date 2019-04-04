//
//  AddNewCellViewController.swift
//  ex00
//
//  Created by Lesha Miroshnik on 4/4/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class AddNewCellViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextView!

    @IBOutlet weak var saveButton: UIBarButtonItem! {
        didSet {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if let firstName = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            firstName.count > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        textField.delegate = self
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        let strDate = dateFormatter.string(from: datePicker.date)
        return strDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homevc = segue.destination as! DeathNoteViewController
        
        guard let name = nameField.text else { return }
        guard var text = textField.text else { return }
        if text == "Type here how he will die" {
            text = ""
        }
        let date = getDate()
        
        let data = Data(name: name, description: text, deathTime: date)
        homevc.deads.append(data)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToFirstVC", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
    }
    
}
