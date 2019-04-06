//
//  APIController.swift
//  Tweety
//
//  Created by Lesha Miroshnik on 4/5/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate: APITwitterDelegate?
    
    let token: String
    let apiURL = "https://api.twitter.com/"
    
    init(withApiDelegate apiDelegate: APITwitterDelegate?, withToken token: String) {
        self.delegate = apiDelegate
        self.token = token
    }
    
    func searchTweets(withSearchWord word: String) {
        let newText = "\"\(word)\""
        guard let theEncodedText = newText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        guard let theUnwrappedURL = URL(string: apiURL + "1.1/search/tweets.json?q=\(theEncodedText)&count=100") else { return }
        
        var request = URLRequest(url: theUnwrappedURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                self.delegate?.error(withError: err)
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary {
                        guard let theArray = dic["statuses"] as? NSArray else { return }
                        var tweets: [Tweet] = []
                        for theElement in theArray {
                            guard let theDecodedElement = theElement as? NSDictionary,
                                let createdAt = theDecodedElement["created_at"] as? String,
                                let text = theDecodedElement["text"] as? String,
                                let user = theDecodedElement["user"] as? NSDictionary,
                                let userName = user["name"] as? String else { continue }
                            tweets.append(Tweet(name: userName, text: text, date: self.formatDate(withString: createdAt)))
                        }
                        self.delegate?.processTweets(tweetsArray: tweets)
                    }
                } catch (let err) {
                    self.delegate?.error(withError: err)
                }
            }
        }.resume()
    }
    
    func formatDate(withString date: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "E MMM dd HH:mm:ss Z yyy"
        guard let newDate = df.date(from: date) else { return "Unknown" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3")
        return dateFormatter.string(from: newDate)
    }
}
