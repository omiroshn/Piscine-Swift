//
//  DiaryTableViewController.swift
//  Diary
//
//  Created by Lesha Miroshnik on 4/13/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import omiroshn2019

class DiaryTableViewController: UITableViewController {

    var theArticles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let theLanguage = Locale.preferredLanguages.first else {
            return
        }
        if theLanguage == "ru-US" || theLanguage == "ru-UA" {
            title = "Мой дневник"
        } else if theLanguage == "uk-US" || theLanguage == "uk-UA" {
            title = "Мій щоденник"
        } else {
            title = "My diary"
        }
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addArticle))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let theLanguage = Locale.preferredLanguages.first else {
            return
        }
        theArticles = ArticleManagerController.shared.getArticles(withLang: theLanguage)
        if theArticles.count > 1 {
            theArticles.sort { $0.modificationDate! > $1.modificationDate! }
        }
        tableView.reloadData()
    }
    
    @IBAction func addArticle() {
        performSegue(withIdentifier: "addArticleClick", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellClick" {
            let indexPath = sender as! IndexPath
            let theDestinationViewController = segue.destination as! AddArticleViewController
            theDestinationViewController.article = theArticles[indexPath.row]
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theArticles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath) as! DiaryTableViewCell
        
        let theDateFormatter = DateFormatter()
        theDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        
        cell.content.text = theArticles[indexPath.row].content
        cell.creationDate.text = theDateFormatter.string(from: theArticles[indexPath.row].creationDate! as Date)
        cell.modificationDate.text = theDateFormatter.string(from: theArticles[indexPath.row].modificationDate! as Date)
        cell.titleLabel.text = theArticles[indexPath.row].title
        cell.diaryImageView.layer.borderWidth = 0.5
        cell.diaryImageView.image = UIImage(data: theArticles[indexPath.row].image! as Data)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellClick", sender: indexPath)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let theArticle = theArticles[indexPath.row]
            DispatchQueue.main.async {
                ArticleManagerController.shared.removeArticle(anArticle: theArticle)
                ArticleManagerController.shared.save()
            }
            theArticles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


extension NSDate: Comparable {
    public static func ==(lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
    }
    
    public static func < (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.compare(rhs as Date) == .orderedAscending
    }
}
