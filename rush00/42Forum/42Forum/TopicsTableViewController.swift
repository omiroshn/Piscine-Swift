//
//  TopicsTableViewController.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController, APIDelegate {

    var apiController: APIController?
    
    var topics: [Topic] = []
    var messages: [TopicMessage] = []
    var topicID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTopics()
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        apiController?.token = ""
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reloadPage(_ sender: UIBarButtonItem) {
        self.getTopics()
    }
    
    @IBAction func addTopicButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addTopic", sender: self)
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicsCell", for: indexPath) as! TopicsTableViewCell
        cell.topicData = self.topics[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topicId = self.topics[indexPath.row].topicId
        self.topicID = topicId
        self.apiController?.getTopicsInfo(withId: topicId, completionHandler: { (messages, error) in
            if let messages = messages {
                self.receiveMessages(messagesArray: messages)
            } else {
                print(error.debugDescription)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.topics[indexPath.row].login == apiController?.myLogin {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.apiController?.deleteTopic(withId: self.topics[indexPath.row].topicId, completionHandler: { (done) in
                if done {
                    self.topics.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    // MARK: - APIDelegate

    func receiveTopics(topicsArray topics: [Topic]) {
        self.topics = topics
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func receiveMessages(messagesArray messages: [TopicMessage]) {
        self.messages = messages
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.performSegue(withIdentifier: "messagesID", sender: self)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTopic" {
            let addtopicvc = segue.destination as! AddTopicViewController
            addtopicvc.apiController = self.apiController
        } else if segue.identifier == "messagesID" {
            let messagesVC = segue.destination as! MessageTableViewController
            messagesVC.messages = self.messages
            messagesVC.apiController = self.apiController
            messagesVC.topidID = self.topicID
        }
    }
    
    @IBAction func unWindToHomeVC(segue: UIStoryboardSegue) {
        self.getTopics()
    }
    
    func getTopics() {
        self.apiController?.getTopics(completionHandler: { (topics, error) in
            if let topics = topics {
                DispatchQueue.main.async {
                    self.receiveTopics(topicsArray: topics)
                }
            } else {
                print(error.debugDescription)
            }
        })
    }
}
