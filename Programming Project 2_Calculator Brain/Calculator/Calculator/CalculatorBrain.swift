//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by shiww on 17/3/3.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import Foundation

struct CalclatorBrain {
  
  //legacy
  //	var result: (result:Double?, isPending:Bool, description:String) {
  //		get {
  //			return evaluate()
  //		}
  //	}
  
  private enum Operation {
    case number(Double)
    case variable(String)
    case constant(Double)
    case unaryOperation((Double) -> Double, (Double) -> String?)
    case binaryOperation((Double,Double) -> Double,(Double, Double) -> String?)
    case nullaryOperation(() -> Double)
    case equals
  }
  
  private var commands = [(operation:Operation, description:String)]()
  
  private var operations: Dictionary<String,Operation> = [
    "π" : Operation.constant(Double.pi),
    "e" : Operation.constant(M_E),
    "√" : Operation.unaryOperation(sqrt, {$0<0 ? "can't square root negative number" : nil}),
    "cos" : Operation.unaryOperation(cos, {_ in nil}),
    "sin" : Operation.unaryOperation(sin, {_ in nil}),
    "%" : Operation.unaryOperation({ $0 / 100.0 }, {_ in nil}),
    "±" : Operation.unaryOperation({ -$0 },{_ in nil}),
    "Rand": Operation.nullaryOperation({Double(arc4random()) / Double(UInt32.max)}),
    "×" : Operation.binaryOperation({ $0 * $1 }, {_,_ in nil}),
    "÷" : Operation.binaryOperation({ $0 / $1 }, {$1 == 0 ? "can't divide by 0" : nil}),
    "+" : Operation.binaryOperation({ $0 + $1 }, {_,_ in nil}),
    "−" : Operation.binaryOperation({ $0 - $1 }, {_,_ in nil}),
    "EE": Operation.binaryOperation({ $0 * pow(10,$1) }, {_,_ in nil}),
    "=" : Operation.equals
  ]
  
  mutating func performOperation(_ symbol: String) {
    if let operation = operations[symbol] {
      commands.append((operation, symbol))
    }
  }
  mutating func setOperand(_ operand: Double) {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 6
    commands.append((Operation.number(operand), numberFormatter.string(from: NSNumber(value: operand))!))
  }
  
  mutating func setOperand(variable named: String) {
    commands.append((Operation.variable(named), named))
  }
  
  mutating func	undoOperation(){
    commands.removeLast(1)
  }
  
  func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String){
    let result = evaluateWithErrorReport(using: variables)
    return (result.result, result.isPending, result.description)
  }
  
  func evaluateWithErrorReport(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String, error: String?) {
    
    var result: (accumulator: Double?, description: String, error: String?) = (nil, " ", nil)
    var pendingBinaryOperation: PendingBinaryOperation?
    
    struct PendingBinaryOperation {
      let function: (Double,Double) -> Double
      let firstOperand: Double
      let errorFunction: (Double, Double) -> String?
      
      func perform(with secondOperand: Double) -> Double {
        return function(firstOperand,secondOperand)
      }
    }
    
    var resultIsPending: Bool {
      return pendingBinaryOperation == nil ? false : true
    }
    
    var dontAppendingAccmulatorWhenPerformPendingBinaryOperation = false
    
    func performOperation(command: (operation:Operation, description:String)) {
      switch command.operation {
        
      case .number(let number):
        result = (number, resultIsPending ? result.description : command.description, nil)
        
      case .variable(let named):
        if resultIsPending {
          dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
        }
        result = (variables?[named] ?? 0 , result.description + command.description, nil)
        break
        
      case .constant(let value):
        dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
        result = (value, result.description + command.description, nil)
        
      case .unaryOperation(let function, let exceptionFunction):
        if let accumulator = result.accumulator {
          if resultIsPending {
            result = (function(accumulator), result.description + command.description + String(accumulator), exceptionFunction(accumulator))
            dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
          } else {
            result = (function(accumulator), command.description + "(\(result.description))", exceptionFunction(accumulator))
            dontAppendingAccmulatorWhenPerformPendingBinaryOperation = false
          }
        }
        
      case .binaryOperation(let function, let exceptionFunction):
        if result.accumulator != nil {
          if resultIsPending {
            performPendingBinaryOperation()
          }
          pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: result.accumulator!,errorFunction: exceptionFunction)
          result = (nil, result.description == " " ? String(result.accumulator!) + command.description : result.description + command.description, nil)
        }
        
      case .nullaryOperation(let function):
        dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
        result = (function(), result.description + command.description, nil)
        
      case .equals:
        performPendingBinaryOperation()
      }
    }
    
    func performPendingBinaryOperation(){
      if resultIsPending, let accumulator = result.accumulator {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 6
        result = (pendingBinaryOperation?.perform(with: accumulator),
                  dontAppendingAccmulatorWhenPerformPendingBinaryOperation == true ? result.description : result.description + numberFormatter.string(from: NSNumber(value: accumulator))!,
                  pendingBinaryOperation?.errorFunction((pendingBinaryOperation?.firstOperand)!, accumulator))
        dontAppendingAccmulatorWhenPerformPendingBinaryOperation = false
        pendingBinaryOperation = nil
      }
    }
    
    for command in commands {
      performOperation(command: command)
    }
    
    return (result.accumulator, resultIsPending, result.description, result.error)
  }
  
  
}
