//
//  ViewController.swift
//  Tweety
//
//  Created by Lesha Miroshnik on 4/5/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let CUSTOMER_KEY = "Xl6SmVJc5YzDDGufYMeT53e8U"
    let CUSTOMER_SECRET = "sYgJKZ8mLuluk7d59i0GdMVPxRpjUiE14PCWuzdV3U94Z3pzFa"
    
    var apiController: APIController?
    var tweetsData: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        indicator.style = .whiteLarge
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor.black
        indicator.layer.cornerRadius = 20.0
        return indicator
    }()
    
    var token: String = "" {
        willSet {
            if newValue != "" {
                self.apiController = APIController(withApiDelegate: self, withToken: newValue)
                self.apiController?.searchTweets(withSearchWord: "trump")
            }
        }
    }
    
    var busyProcesses: Int = 0 {
        didSet {
            if oldValue == 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.startActivityIndicator()
                }
            }
        }
        willSet {
            if newValue == 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.stopActivityIndicator()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        
        containerView.backgroundColor = UIColor.gray
        containerView.alpha = 0.8
        containerView.addSubview(activityIndicator)
        activityIndicator.center = containerView.center
        busyProcesses += 1
        getAuthorizationToken()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let apiController = self.apiController else {
            alertPopUp(withMessage: "Some problems with API Controller, try again")
            return false
        }
        guard let trimmedText = textField.text else {
            alertPopUp(withMessage: "Invalid text")
            return false
        }
        guard trimmedText.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            alertPopUp(withMessage: "Empty text, type something!")
            return false
        }
        view.endEditing(true)
        busyProcesses += 1
        apiController.searchTweets(withSearchWord: trimmedText)
        return true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetInfoCell
        
        if tweetsData.count > 0 {
            cell.tweet = tweetsData[indexPath.row]
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: APITwitterDelegate {
    func processTweets(tweetsArray tweets: [Tweet]) {
        tweetsData = tweets
        busyProcesses -= 1
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func error(withError error: Error) {
        print(error)
        self.alertPopUp(withMessage: error.localizedDescription)
    }
}

extension ViewController {
    func alertPopUp(withMessage message: String) {
        if busyProcesses != 0 {
            busyProcesses -= 1
        }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startActivityIndicator() {
        containerView.alpha = 0.8
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopActivityIndicator() {
        containerView.alpha = 0
        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension ViewController {
    func getAuthorizationToken() {
        let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("Basic \(BEARER)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                self.error(withError: err)
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                        guard let token = dic["access_token"] as? String else {return}
                        self.token = token
                    }
                } catch (let err) {
                    self.error(withError: err)
                }
            }
        }.resume()
    }
}
