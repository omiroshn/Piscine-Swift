//
//  AddMessageViewController.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController, UITextViewDelegate {

    var apiController: APIController?
    var topicID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        if let content = textView.text {
            if content.count > 0 {
                if let id = topicID {
                    self.apiController?.addNewMessage(withTopicId: id, withContent: content)
                    self.performSegue(withIdentifier: "exitFromDoneMessage", sender: self)
                }
            } else {
                print("count 0")
            }
        } else {
            print("topicName nil")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let msgVC = segue.destination as! MessageTableViewController
        msgVC.tableView.reloadData()
    }
}
