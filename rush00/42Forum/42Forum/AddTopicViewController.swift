//
//  AddTopicViewController.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class AddTopicViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var apiController: APIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textView.delegate = self
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem! {
        didSet {
            doneButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        if let topicName = textField.text, let content = textView.text {
            if topicName.count > 0, content.count > 0 {
                self.apiController?.addNewTopic(withContent: content, withTopicName: topicName)
                self.performSegue(withIdentifier: "exitFromDoneTopic", sender: self)
            } else {
                print("count 0")
            }
        } else {
            print("topicName nil")
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField?) {
        if let textField = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            textField.count > 0{
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let topicsVC = segue.destination as! TopicsTableViewController
        topicsVC.getTopics()
        topicsVC.tableView.reloadData()
    }
    
}
