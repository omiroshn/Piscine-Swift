//
//  AddArticleViewController.swift
//  Diary
//
//  Created by Lesha Miroshnik on 4/23/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import omiroshn2019

class AddArticleViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var articleTextField: UITextField!
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveArticle))
        
        hideKeyboard()
        articleTextView.layer.borderWidth = 2
        articleImageView.layer.borderWidth = 2
        
        guard let theArticle = article else { return }
        articleTextField.text = theArticle.title
        guard let theContent = theArticle.content else { return }
        articleTextView.text = theContent
        guard let theImageData = theArticle.image else { return }
        articleImageView.image = UIImage(data: theImageData as Data)
    }
    
    @IBAction func saveArticle() {
        view.endEditing(true)
        let title = articleTextField.text
        guard title?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            let title = NSLocalizedString("Error", comment: "")
            let msg = NSLocalizedString("Title is empty", comment: "")
            showAlert(withTitle: title, withMessage: msg)
            return
        }
        let content = articleTextView.text
        guard content?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            let title = NSLocalizedString("Error", comment: "")
            let msg = NSLocalizedString("Content is empty", comment: "")
            showAlert(withTitle: title, withMessage: msg)
            return
        }
        guard let image = articleImageView.image else {
            let title = NSLocalizedString("Error", comment: "")
            let msg = NSLocalizedString("Image is empty", comment: "")
            showAlert(withTitle: title, withMessage: msg)
            return
        }
        guard let pngImage = image.jpegData(compressionQuality: 1) else {
            let title = NSLocalizedString("Error", comment: "")
            let msg = NSLocalizedString("Problem with image, sorry", comment: "")
            showAlert(withTitle: title, withMessage: msg)
            return
        }
        
        if let theArticle = self.article {
            theArticle.title = title
            theArticle.content = content
            theArticle.image = pngImage as NSData
            theArticle.modificationDate = NSDate()
            ArticleManagerController.shared.save()
        } else {
            let theArticle = ArticleManagerController.shared.newArticle()
            theArticle.title = title
            theArticle.content = content
            theArticle.image = pngImage as NSData
            theArticle.language = Locale.preferredLanguages.first!
            theArticle.creationDate = NSDate()
            theArticle.modificationDate = NSDate()
            ArticleManagerController.shared.save()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imageController = UIImagePickerController()
            imageController.delegate = self
            imageController.sourceType = .photoLibrary
            imageController.allowsEditing = false
            self.present(imageController, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imageController = UIImagePickerController()
            imageController.delegate = self
            imageController.sourceType = .camera
            imageController.allowsEditing = false
            self.present(imageController, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            articleImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
