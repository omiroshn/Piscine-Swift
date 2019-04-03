//
//  ViewController.swift
//  ex00
//
//  Created by Lesha Miroshnik on 4/3/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

struct Data {
    static let names : [(String, String)] = [
        ("Light Yagami", "Died as Ryuk himself took his life by writing his name in his Death Note just before Light suffered from a bullet wound"),
        ("L", "Kira used this to make L as a threat to Misa. And when a shinigami write to protect a people, they disintegrated into a dust. They dies. He dies because light always wanted him dead so he used rem to kill l and rem wrote the watari and l name his death note after that he dies."),
        ("Misa Amane", "The author speculated that after someone \"like Matsuda probably let it slip\" that Light died, Misa fell into despair and \"committed suicide... something like that\". Her death date is given as slightly over a year after Light's."),
    ]
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell")
        cell?.textLabel?.text = Data.names[indexPath.row].0
        cell?.detailTextLabel?.text = Data.names[indexPath.row].1
        return cell!
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
}
