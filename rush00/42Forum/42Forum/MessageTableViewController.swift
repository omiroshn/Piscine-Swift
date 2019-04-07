//
//  MessageTableViewController.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {

    var apiController: APIController?
    var messages: [TopicMessage] = []
    var topidID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addMessageButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addMessage", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].replies.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        if indexPath.row == 0 {
            cell.topicMessageData = self.messages[indexPath.section]
        } else {
            cell.topicMessageDataReply = self.messages[indexPath.section].replies[indexPath.row-1]
            cell.contentView.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMessage" {
            let addmsgvc = segue.destination as! AddMessageViewController
            addmsgvc.apiController = self.apiController
            addmsgvc.topicID = self.topidID
        }
    }
    
    @IBAction func unWindToHomeVC(segue: UIStoryboardSegue) {
    }

}
