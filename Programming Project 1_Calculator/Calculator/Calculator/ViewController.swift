//
//  ViewController.swift
//  Calculator
//
//  Created by shiww on 17/3/2.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var descriptionDisplay: UILabel!
  
  override func viewDidLoad() {
    descriptionDisplay.text = " "
  }
  
  var userIsInTheMiddleOfTyping = false
  
  var displayValue: Double {
    get {
      return Double(display.text!)!
    }
    set {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      numberFormatter.maximumFractionDigits = 6
      display.text = numberFormatter.string(from: NSNumber(value: newValue))
    }
  }
  
  private var brain = CalclatorBrain()
  
  @IBAction func touchDigit(_ sender: UIButton) {
    let digit = sender.currentTitle!
    if userIsInTheMiddleOfTyping {
      let textCurrentlyInDisplay = display.text!
      
      if  textCurrentlyInDisplay.contains(".") && digit == "." {
        return
      } else{
        display.text = textCurrentlyInDisplay + digit
      }
      
    } else {
      display.text = digit
      userIsInTheMiddleOfTyping = true
    }
  }
  
  @IBAction func performOperation(_ sender: UIButton) {
    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      userIsInTheMiddleOfTyping = false
    }
    
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }
    
    if let accumulator = brain.result.accumulator {
      displayValue = accumulator
    }
    
    if brain.resultIsPending {
      descriptionDisplay.text = brain.result.description + "..."
    }else{
      descriptionDisplay.text = brain.result.description == " " ? " " : brain.result.description + "="
    }
    
  }
  @IBAction func backsapce(_ sender: Any) {
    if userIsInTheMiddleOfTyping {
      if var operand = display.text {
        operand.remove(at: operand.index(before: operand.endIndex))
        display.text = " " + operand
      }
    }
  }
}

