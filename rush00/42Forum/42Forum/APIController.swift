//
//  APIController.swift
//  42Forum
//
//  Created by Lesha Miroshnik on 4/7/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import SafariServices
import AuthenticationServices

class APIController {
    
    weak var delegate: APIDelegate?
    var authSession: ASWebAuthenticationSession?
    
    var myLogin: String = ""
    var myId: Int = 0
    var token: String = ""
    let API_URL = "https://api.intra.42.fr/"
    let UID = "0bb6318eb7803f3b835d0e0ccf38ce0a006e7c7b1a4564333d010ba07e07b3e4"
    let SECRET = "3d93533513d0e675149e8b3d9548742c7ddbd32de6f2e66841112956c815809b"
    let CALLBACK = "rush00%3A%2F%2Fauth"
    
    init(withApiDelegate apiDelegate: APIDelegate?) {
        self.delegate = apiDelegate
    }
    
    func requestSafari() {
        let url = API_URL + "oauth/authorize?client_id=\(UID)&redirect_uri=\(CALLBACK)&response_type=code&scope=public%20forum"
        
        self.authSession = ASWebAuthenticationSession(url: URL(string: url)! as URL, callbackURLScheme: CALLBACK, completionHandler: {  (callBack: URL?, error: Error?) in
            guard error == nil, let successURL = callBack else { return }
            guard let code = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first else { return }
            self.requestToken(withCode: code)
        })
        
        self.authSession?.start()
    }
    
    func setToken(withToken token: String) {
        self.token = token
    }
    
    func requestToken(withCode code: URLQueryItem) {
        let url = API_URL + "oauth/token"
        var request = URLRequest(url: URL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(SECRET)&\(code)&redirect_uri=\(CALLBACK)".data(using: String.Encoding.utf8)
        
        let _ = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    print(dic)
                    guard let token = dic["access_token"] as? String else {return}
                    self.token = token
                    print("Access token: \(token)")
                    self.getMyLogin()
                    self.getTopics(completionHandler: { (topics, error) in
                        if let topics = topics {
                            DispatchQueue.main.async {
                                self.delegate?.receiveTopics(topicsArray: topics)
                            }
                        } else {
                            print(error.debugDescription)
                        }
                    })
                } catch (let error) {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getTopics(completionHandler:@escaping ([Topic]?, Error?)->Void) {
        let url = URL(string: API_URL + "v2/topics.json")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let array = try JSONSerialization.jsonObject(with: data, options: []) as? Array<NSDictionary>
                    var topics = [Topic]()
                    
                    for dict in array! {
                        let id = dict["id"] as! Int
                        let date = dict["created_at"] as! String
                        let formattedDate = self.formatDate(withString: date)
                        
                        let topicName = dict["name"] as! String
                        
                        let author = dict["author"] as? NSDictionary
                        let login = author!["login"] as! String
                        
                        let topic = Topic(topicId: id, login: login, topicName: topicName, topicDate: formattedDate)
                        
                        topics.append(topic)
                    }
                    completionHandler(topics, nil)
                } catch (let error) {
                    completionHandler(nil, error)
                }
            }
        }.resume()
    }
    
    func formatDate(withString date: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let newDate = df.date(from: date) else { return "Unknown" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3")
        return dateFormatter.string(from: newDate)
    }
    
    func getTopicsInfo(withId id: Int, completionHandler:@escaping ([TopicMessage]?, Error?)->Void) {
        let url = URL(string: API_URL + "v2/topics/\(id)/messages")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "GET"
        print(self.token)
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let array = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<NSDictionary>
                    var messages = [TopicMessage]()
                    
                    for dict in array! {
                        let date = dict["created_at"] as! String
                        let formattedDate = self.formatDate(withString: date)
                        let content = dict["content"] as! String
                        let author = dict["author"] as? NSDictionary
                        let login = author!["login"] as! String
                        let replies = dict["replies"] as? [NSDictionary]
                        
                        var repliesArray = [Reply]()
                        for reply in replies! {
                            let author = reply["author"] as? NSDictionary
                            let login = author!["login"] as! String
                            let content = reply["content"] as! String
                            let date = reply["created_at"] as! String
                            let formattedDate = self.formatDate(withString: date)
                            let r = Reply(login: login, content: content, date: formattedDate)
                            repliesArray.append(r)
                        }
                        
                        let msg = TopicMessage(login: login, content: content, date: formattedDate, replies: repliesArray)
                        messages.append(msg)
                    }
                    completionHandler(messages, nil)
                } catch (let error) {
                    completionHandler(nil, error)
                }
            }
        }.resume()
    }
    
    func addNewTopic(withContent content: String, withTopicName name: String) {
        let url = URL(string: API_URL + "v2/topics.json")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let new = [
            "topic": [
                "author_id": nil,
                "cursus_ids": ["1"],
                "kind": "normal",
                "messages_attributes": [
                    [
                        "content": content,
                    ],
                ],
                "name": name,
                "tag_ids": ["574"],
            ],
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: new, options: .prettyPrinted)
        request.httpBody = jsonData
        
        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: [])
                    print(dic)
                } catch (let error) {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getMyLogin() {
        let url = URL(string: API_URL + "v2/me")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    self.myLogin = dict!["login"] as! String
                    self.myId  = dict!["id"] as! Int
                }
                catch (let error) {
                    print(error)
                }
            }
        }.resume()
    }
    
    func deleteTopic(withId id: Int, completionHandler:@escaping (_: Bool)->Void) {
        let url = URL(string: API_URL + "v2/topics/\(id).json")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completionHandler(false)
            } else if let _ = data {
                completionHandler(true)
            }
        }.resume()
    }

    func addNewMessage(withTopicId topicID: Int, withContent content: String) {
        let url = URL(string: API_URL + "v2/topics/\(topicID)/messages")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let new = [
            "message": [
                "author_id": nil,
                "content": content,
                "messageable_id": "7",
                "messageable_type": "Topic"
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: new, options: .prettyPrinted)
        request.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: [])
                    print(dic)
                } catch (let error) {
                    print(error)
                }
            }
        }.resume()
    }
    
}
