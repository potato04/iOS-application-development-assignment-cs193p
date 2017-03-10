//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by shiww on 17/3/3.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import Foundation

struct CalclatorBrain {
  
  public private(set) var result: (accumulator:Double?, description:String) = (nil," ")
  
  private enum Operation {
    case constant(Double)
    case unaryOperation((Double) -> Double)
    case binaryOperation((Double,Double) -> Double)
    case equals
    case clear
  }
  
  private var operations: Dictionary<String,Operation> = [
    "π" : Operation.constant(Double.pi),
    "e" : Operation.constant(M_E),
    "√" : Operation.unaryOperation(sqrt),
    "cos" : Operation.unaryOperation(cos),
    "sin" : Operation.unaryOperation(sin),
    "%" : Operation.unaryOperation({ $0 / 100.0 }),
    "±" : Operation.unaryOperation({ -$0 }),
    "×" : Operation.binaryOperation({ $0 * $1 }),
    "÷" : Operation.binaryOperation({ $0 / $1 }),
    "+" : Operation.binaryOperation({ $0 + $1 }),
    "−" : Operation.binaryOperation({ $0 - $1 }),
    "EE": Operation.binaryOperation({ $0 * pow(10,$1) }),
    "=" : Operation.equals,
    "C" : Operation.clear
    
  ]
  
  private var pendingBinaryOperation: PendingBinaryOperation?
  
  private struct PendingBinaryOperation {
    let function: (Double,Double) -> Double
    let firstOperand: Double
    
    func perform(with secondOperand: Double) -> Double {
      return function(firstOperand,secondOperand)
    }
  }
  

  
  var resultIsPending: Bool {
    return pendingBinaryOperation == nil ? false : true
  }
  var binaryOperationShouldNotAppendAccmulator = false
  
  mutating func performOperation(_ symbol: String) {
    if let constant = operations[symbol] {
      switch constant {
      
      case .constant(let value):
        result = (value, result.description + symbol)
        break
        
      case .unaryOperation(let function):
        if result.accumulator != nil {
          if resultIsPending {
            result = (function(result.accumulator!), result.description + symbol + String( result.accumulator!))
            binaryOperationShouldNotAppendAccmulator = true
          }else{
            result = (function(result.accumulator!), symbol + "(\(result.description))")
          }
        }
        break
      
      case .binaryOperation(let function):
        if result.accumulator != nil {
          if resultIsPending {
            performPendingBindaryOperation()
          }
          pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: result.accumulator!)
          result = (nil, result.description == " " ?
          String(result.accumulator!) + symbol : result.description + symbol )
        }
        break
      
      case .equals:
        performPendingBindaryOperation()
        break
      
      case .clear:
        result = (0, " ")
        pendingBinaryOperation = nil
        break;
      }
    
    }
  }
  
  private mutating func performPendingBindaryOperation(){
    if resultIsPending && result.accumulator != nil{
      
      result = (pendingBinaryOperation?.perform(with: result.accumulator!),
                binaryOperationShouldNotAppendAccmulator == true ? result.description : result.description + String(result.accumulator!))
      
      binaryOperationShouldNotAppendAccmulator = false
      pendingBinaryOperation = nil
    }
  }
  
  mutating func setOperand(_ operand: Double) {
    result = (operand, pendingBinaryOperation == nil ? String(operand) : result.description)
  }
  
  
}
