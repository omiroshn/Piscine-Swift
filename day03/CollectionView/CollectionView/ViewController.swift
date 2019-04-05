//
//  ViewController.swift
//  CollectionView
//
//  Created by Lesha Miroshnik on 4/5/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let burgerArray = [
        "BigMac",
        "BigTasty",
        "Double Cheeseburger",
        "Maestro",
        "Hamburger",
        "Cheeseburger",
        "Cheeseburger bacon",
        "McChicken",
        "File O'Fish",
        "Camamber Toast",
        "Chicken McNuggets 6",
        "Chicken McNuggets 9",
        "Chicken Roll",
        "French Fries L",
        "French Fries M",
        "FF /w cheese & onion",
        "French Fries S",
        "CocaCola L",
        "Fanta L",
        "Sprite L",
        "Orange juice",
        "McFlurry Caramel",
        "McFlurry Chocolate",
        "McSundae",
        "McShake",
        "Muffin"
    ]
    
    let burgerURLS = [
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_BigMac.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_BigTasty.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_DoubleCheeseburger.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Maestro%20Classic%20Beef.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_Hamburger.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_Cheeseburger.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_CheeseburgerBacon.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_McChicken.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_File-o-Fish.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.Sdwch_McToastCamambert.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.ChickenMcNuggets6.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.ChickenMcNuggets9.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.RollChicken.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.FFLarge.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.FFMedium.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.French%20fries%20with%20cheese%20and%20onion.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.FFSmall.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.CocaColaLarge.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.FantaLarge.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.SpriteLarge.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.JuiceOrangeMedium.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.McFlurryKitKatCaramel.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.McFlurryKitKatChocolate.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.McSundaeStrawberryWaffle.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.McPieCherry.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.McShakeStrawberryMedium.png",
        "https://www.mcdonalds.ua/content/dam/Ukraine/Item_Images/hero.MuffinBlackberry.png"
    ]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return burgerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        spinner(spinner: cell.activityIndicator, shoudSpin: true)
        
        let url = URL(string: burgerURLS[indexPath.item])!
        getData(from: url) { data, response, error in
            
            if error != nil || data == nil {
                self.alertPopUp(stringName: response?.suggestedFilename ?? url.lastPathComponent)
                print(error!)
                return
            }
            
            DispatchQueue.main.async() {
                cell.hamburgerImageView.image = UIImage(data: data!)
                self.spinner(spinner: cell.activityIndicator, shoudSpin: false)
            }
        }
        
        cell.hamburgerLabel.text = burgerArray[indexPath.item]
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        
        return cell
    }
    
    //MARK: - performSegue
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "cellSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! CollectionViewCell
        let imagevc = segue.destination as! ImageSelectorViewController
        guard let image = cell.hamburgerImageView.image else {return}
        imagevc.image = image
    }
    
    //MARK: - image loading
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func spinner(spinner: UIActivityIndicatorView, shoudSpin status: Bool) {
        if status == true {
            spinner.isHidden = false
            spinner.startAnimating()
        } else {
            spinner.isHidden = true
            spinner.stopAnimating()
        }
    }
    
    func alertPopUp(stringName: String) {
        print(stringName)
        let alert = UIAlertController(title: "ERROR", message: "Image \(stringName) can't be loaded", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("Alert PopUp")
        })
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}
