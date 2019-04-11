//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Oleksii MIROSHNYK on 4/11/19.
//  Copyright © 2019 Oleksii MIROSHNYK. All rights reserved.
//

import UIKit
import DarkSkyKit
import RecastAI
import MessageKit
import Speech

class ChatViewController: MessagesViewController, SFSpeechRecognizerDelegate {
    
    var recastBot: RecastAIClient = RecastAIClient(token: "9d5fd52289aa2a88f703c5efee59498d", language: "ru")
    var forecastCli: DarkSkyKit = DarkSkyKit(apiToken: "a3fcaf1a16476dc54433789ed4354e03")
    
    var messages: [Message] = []
    var member: Member!
    var chatBot: Member!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member = Member(name: "omiroshn", color: .orange)
        chatBot = Member(name: "ForecastBot", color: .purple)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        speechRecognizer?.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(voiceController))
        self.requestSpeechPermissions()
        
        self.showMessageFromBot(withText: "Hi!\nI'm a weather wizzard🧙🏻‍♂️\nType here a city or country and I will give you a forecast🌦.\ne.g: Kyiv and Lviv")
    }
    
    @IBAction func voiceController() {
        guard let theText = navigationItem.rightBarButtonItem?.title else { return }
        
        if theText == "Voice" {
            navigationItem.rightBarButtonItem?.title = "Stop"
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, _) in
                self?.request.append(buffer)
            }
            request.shouldReportPartialResults = true
            audioEngine.prepare()
            do {
                try audioEngine.start()
            } catch (let theError) {
                return print(theError)
            }
            guard let theRecognizer = SFSpeechRecognizer() else { return }
            if !theRecognizer.isAvailable { return }
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] (result, error) in
                if let theResult = result {
                    let theBestString = theResult.bestTranscription.formattedString
                    self?.messageInputBar.inputTextView.text = theBestString
                } else if let theError = error {
                    print(theError)
                    if self?.audioEngine != nil {
                        self?.audioEngine.stop()
                        self?.audioEngine.inputNode.removeTap(onBus: 0)
                        self?.recognitionTask = nil
                    }
                }
            })
        } else {
            navigationItem.rightBarButtonItem?.title = "Voice"
            recognitionTask?.cancel()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    func requestSpeechPermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                case .denied:
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                    self?.showMessageFromBot(withText: "You denied access to speech recognition")
                case .restricted:
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                    self?.showMessageFromBot(withText: "Speech recognition restricted on this device")
                case .notDetermined:
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                    self?.showMessageFromBot(withText: "Speech recognition not yet authorized")
                }
            }
        }
    }
    
    func makeRecastBotRequest(withText text: String) {
        self.recastBot.textRequest(text, successHandler: { [weak self] (responce) in
            guard let status = responce.status, status == 200 else {
                self?.showMessageFromBot(withText: "Wrong responce status")
                return
            }
            guard let _ = responce.intents, let entities = responce.entities else {
                self?.showMessageFromBot(withText: "Not enought information, try to input correctly your location")
                return
            }
            print(entities)
            guard let locations = entities["location"] as? [NSDictionary] else {
                self?.showMessageFromBot(withText: "Not enought information, try to input correctly your location")
                return
            }
            for location in locations {
                guard let lat = location["lat"] as? Double, let lng = location["lng"] as? Double, let name = location["raw"] as? String else {
                    self?.showMessageFromBot(withText: "Not enought information, try to input correctly your location")
                    return
                }
                self?.forecastCli.current(latitude: lat, longitude: lng) { [weak self] (result) in
                    switch result {
                    case .success(let forecast):
                        if let current = forecast.currently {
                            guard let t = current.temperature else {return}
                            guard let s = current.summary else {return}
                            guard let temp = self?.convertToCelsius(fahrenheit: t) else {return}
                            let text = "Weather in \(name) is:\n\(s), \(temp)°C"
                            self?.showMessageFromBot(withText: text)
                        }
                    case .failure(let error):
                        self?.showError(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }) { [weak self] (error) in
            self?.showError(title: "Error", message: error.localizedDescription)
        }
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
    }
    
    func convertToCelsius(fahrenheit: Double) -> Int {
        return Int(5.0 / 9.0 * (fahrenheit - 32.0))
    }
    
    func showMessageFromBot(withText text: String) {
        let newMessage = Message(
            member: chatBot,
            text: text,
            messageId: UUID().uuidString)
        messages.append(newMessage)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}

extension ChatViewController : MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)]
        )
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
}

extension ChatViewController : MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

extension ChatViewController : MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.row]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension ChatViewController : MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        view.endEditing(true)
        
        guard text.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            showError(title: "Error", message: "Missing text")
            return
        }
        
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        
        makeRecastBotRequest(withText: text)
    }
}
