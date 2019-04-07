//
//  ViewController.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/6/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APIDelegate {
    
    var apiController: APIController?
    var topics: [Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiController = APIController(withApiDelegate: self)
    }

    @IBAction func safari(_ sender: Any) {
        self.apiController?.requestSafari()
    }
    
    //MARK: - APIDelegate
    
    func receiveTopics(topicsArray topics: [Topic]) {
        self.topics = topics
        self.performSegue(withIdentifier: "topicsID", sender: self)
    }
    
    func receiveMessages(messagesArray messages: [TopicMessage]) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let topicsVC = segue.destination as? TopicsTableViewController else {return}
        topicsVC.topics = self.topics
        topicsVC.apiController = self.apiController
    }
}

