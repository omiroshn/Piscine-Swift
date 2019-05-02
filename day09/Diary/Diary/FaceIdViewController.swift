//
//  ViewController.swift
//  Diary
//
//  Created by Lesha Miroshnik on 4/13/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import omiroshn2019
import LocalAuthentication

class FaceIdViewController: UIViewController {

    var theArticleManager = ArticleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theArticles = theArticleManager.getAllArticles()
        if theArticles.count == 0 {
            let article1 = theArticleManager.newArticle()
            article1.title = "Время"
            article1.content = "На волны можно смотреть часами. Смотреть и ни о чем не думать, ни о чем не говорить. Наверное, волны как и время, лечат. Волны, как и время, уносят старое, принося что-то новое.\nНаверное достаточно слов, предлагаю просто помолчать..."
            article1.creationDate = NSDate()
            article1.modificationDate = NSDate()
            article1.language = Locale.preferredLanguages.first!
            article1.image = UIImage(named: "sea")!.pngData() as NSData?
            theArticleManager.save()
            
            let article2 = theArticleManager.newArticle()
            article2.title = "Гамарджоба, Грузия!"
            article2.content = "Улетаю сегодня в Грузию учить детей фотографии в рамках детского проекта лагеря ЭкстреМал. Снова увижу любимый Кавказ, но уже с грузинской стороны. Посмотрю на наверное самую фотогеничную вершину Северного Кавказа - Ушбу. На фото она же, только снятая со склона Эльбруса. Две недели мы с детьми проведем в Местии - городке в Сванетии, давно уже ставшей меккой для фотографов. Всегда люблю работать с детьми - они самые благодарные слушатели, да и схватывают все просто на лету!\nРезультатом нашей работы станут детские творческие проекты - каждый из киндеров выберет какую-то тему, и будет работать над ней до конца смены. А потом - итоговая выставка в Киеве, так что уже там буду рад видеть всех вас )\nЯ же торжественно обязуюсь писать о наших приключениях в этих удивительных краях, рассказывать о сванах - крепких и выносливых горцах. Главное чтобы был интернет ))\n\nДа и вообще я в большом предвкушении от встречи с Грузией. Все, кто там был, говорят, что это очень дружелюбная страна. ну это мы проверим. Кто из вас был там, поделитесь впечатлениями!"
            article2.creationDate = NSDate()
            article2.modificationDate = NSDate()
            article2.language = Locale.preferredLanguages.first!
            article2.image = UIImage(named: "mountains")!.pngData() as NSData?
            theArticleManager.save()
            
            let article3 = theArticleManager.newArticle()
            article3.title = "Звездная пыль"
            article3.content = "Очень сильно люблю горы... да вы все это уже давно знаете. А еще люблю ночное звездное небо. И когда я получаю все это одновременно - счастью моему нет предела!"
            article3.creationDate = NSDate()
            article3.modificationDate = NSDate()
            article3.language = Locale.preferredLanguages.first!
            article3.image = UIImage(named: "stars")!.pngData() as NSData?
            theArticleManager.save()
            
            let article4 = theArticleManager.newArticle()
            article4.title = "Глубокое небо гор"
            article4.content = "Вид на Главный Кавказский хребет со склона Эльбруса. Высота что-то около 4000. Тяжелая, тяжелая ночь с горняшкой.. Как тяжело завязывать шнурки - наклонился к ним и заболела голова. Завязал один шнурок - и устал невероятно.. А потом ночь, наполненная мигренью.."
            article4.creationDate = NSDate()
            article4.modificationDate = NSDate()
            article4.language = Locale.preferredLanguages.first!
            article4.image = UIImage(named: "sky")!.pngData() as NSData?
            theArticleManager.save()
        }
    }
    
    var passwordPassed: Bool?
    
    @IBAction func faceIDButton(_ sender: UIButton) {
        let context = LAContext()
        let reason = "Use your finder to enter"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (wasCorrect, error) in
                DispatchQueue.main.async {
                    if wasCorrect {
                        print("Correct")
                        self.performSegue(withIdentifier: "toTableFromFaceId", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "password", sender: self)
                    }
                }
            }
        } else {
            let title = NSLocalizedString("Biometry unavailable", comment: "")
            let msg = NSLocalizedString("Your device is not configured for biometric authentication.", comment: "")
            showAlert(withTitle: title, withMessage: msg)
        }
    }
    
}

extension UIViewController {
    
    func showAlert(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
