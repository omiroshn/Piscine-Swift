//
//  ViewController.swift
//  ex02
//
//  Created by Lesha Miroshnik on 4/1/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

@IBDesignable class myButton : UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func ACButton(_ sender: myButton) {
        textLabel.text = "0"
        print("Erased")
    }
    
    @IBAction func plusMinusButton(_ sender: myButton) {
        if let text = textLabel.text {
            if text != "0" {
                if !text.contains("-") {
                    textLabel.text = "-" + text
                } else {
                    textLabel.text = text.replacingOccurrences(of: "-", with: "")
                }
            }
        } else {
            print("Error plusMinus")
        }
        print("+/-")
    }
    
    @IBAction func percentButton(_ sender: myButton) {
        print("%")
    }
    
    @IBAction func divButton(_ sender: myButton) {
        print("/")
    }
    
    @IBAction func multButton(_ sender: myButton) {
        print("*")
    }
    
    @IBAction func minusButton(_ sender: myButton) {
        print("-")
    }
    
    @IBAction func plusButton(_ sender: myButton) {
        print("+")
    }
    
    @IBAction func equalsButton(_ sender: myButton) {
        print("=")
    }
    
    @IBAction func zero(_ sender: myButton) {
        textLabel.text = "0"
        print("0")
    }
    @IBAction func one(_ sender: myButton) {
        textLabel.text = "1"
        print("1")
    }
    @IBAction func two(_ sender: myButton) {
        textLabel.text = "2"
        print("2")
    }
    @IBAction func three(_ sender: myButton) {
        textLabel.text = "3"
        print("3")
    }
    @IBAction func four(_ sender: myButton) {
        textLabel.text = "4"
        print("4")
    }
    @IBAction func five(_ sender: myButton) {
        textLabel.text = "5"
        print("5")
    }
    @IBAction func six(_ sender: myButton) {
        textLabel.text = "6"
        print("6")
    }
    @IBAction func seven(_ sender: myButton) {
        textLabel.text = "7"
        print("7")
    }
    @IBAction func eight(_ sender: myButton) {
        textLabel.text = "8"
        print("8")
    }
    @IBAction func nine(_ sender: myButton) {
        textLabel.text = "9"
        print("9")
    }
    @IBAction func coma(_ sender: myButton) {
        if let text = textLabel.text {
            if !text.contains(",") {
                textLabel.text = text + ","
                print(",")
            }
        } else {
            print("Error coma")
        }
    }

}
