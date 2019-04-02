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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textLabel: UILabel!
    var stillTyping: Bool = false
    var dotsPlaced: Bool = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operatorSign: String = ""
    
    var currentInput: Double {
        get {
            if let text = textLabel.text {
                if text == "Error" {
                    return 0
                } else {
                    return Double(text)!
                }
            } else {
                return 0
            }
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.split(separator: ".")
            if Int(valueArray[1]) == 0 {
                if dotsPlaced == true {
                    textLabel.text = "\(valueArray[0])."
                } else {
                    textLabel.text = "\(valueArray[0])"
                }
            } else {
                textLabel.text = String(format: "%g", newValue)
            }
            stillTyping = false
        }
    }
    
    @IBAction func numberButton(_ sender: myButton) {
        if stillTyping {
            if textLabel.text!.count < 9 {
                if textLabel.text!.first == "0", !dotsPlaced {
                    textLabel.text = sender.currentTitle!
                } else {
                    textLabel.text = textLabel.text! + sender.currentTitle!
                }
            }
        } else {
            textLabel.text = sender.currentTitle!
            stillTyping = true
        }
        print(sender.currentTitle!)
    }

    @IBAction func ACButton(_ sender: myButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        stillTyping = false
        dotsPlaced = false
        operatorSign = ""
        textLabel.text = "0"
        print("Erased")
    }
    
    @IBAction func plusMinusButton(_ sender: myButton) {
        currentInput = -currentInput
        print("+/-")
    }
    
    @IBAction func percentButton(_ sender: myButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput /  100
        }
        stillTyping = false
        print("%")
    }
    
    @IBAction func equalsButton(_ sender: myButton) {
        if stillTyping {
            secondOperand = currentInput
        }
        
        dotsPlaced = false
        stillTyping = false
        
        switch operatorSign {
        case "+":
            currentInput = firstOperand + secondOperand
        case "-":
            currentInput = firstOperand - secondOperand
        case "×":
            currentInput = firstOperand * secondOperand
        case "÷":
            if secondOperand == 0 {
                currentInput = 0
                textLabel.text = "Error"
            } else {
                currentInput = firstOperand / secondOperand
            }
        default:
            break
        }
    }
    
    @IBAction func operandsButton(_ sender: myButton) {
        operatorSign = sender.currentTitle!
        firstOperand = currentInput
        stillTyping = false
        dotsPlaced = false
        print(operatorSign)
    }
    
    @IBAction func coma(_ sender: myButton) {
        if stillTyping && !dotsPlaced {
            textLabel.text = textLabel.text! + "."
        } else if !stillTyping && !dotsPlaced {
            textLabel.text = "0."
        }
        dotsPlaced = true
        print(".")
    }

}
