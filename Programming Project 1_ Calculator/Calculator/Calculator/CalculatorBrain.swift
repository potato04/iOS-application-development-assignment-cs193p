//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by shiww on 17/3/3.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import Foundation

struct CalclatorBrain {
  
  private var accumulator: Double?
  
  private enum Operation {
    case constant(Double)
    case unaryOperation((Double) -> Double)
    case binaryOperation((Double,Double) -> Double)
    case equals
  }
  
  private var operations: Dictionary<String,Operation> = [
    "π" : Operation.constant(Double.pi),
    "e" : Operation.constant(M_E),
    "√" : Operation.unaryOperation(sqrt),
    "cos" : Operation.unaryOperation(cos),
    "±" : Operation.unaryOperation({ -$0 }),
    "×" : Operation.binaryOperation({ $0 * $1 }),
    "÷" : Operation.binaryOperation({ $0 / $1 }),
    "+" : Operation.binaryOperation({ $0 + $1 }),
    "−" : Operation.binaryOperation({ $0 - $1}),
    "=" : Operation.equals
    
  ]
  
  private var pendingBinaryOperation: PendingBinaryOperation?
  
  private struct PendingBinaryOperation {
    let function: (Double,Double) -> Double
    let firstOperand: Double
    
    func perform(with secondOperand: Double) -> Double {
      return function(firstOperand,secondOperand)
    }
  }
  
  var result: Double? {
      return accumulator
  }
  
  mutating func performOperation(_ symbol: String) {
    if let constant = operations[symbol] {
      switch constant {
      case .constant(let value):
        accumulator = value
        break
      case .unaryOperation(let function):
        if accumulator != nil {
          accumulator = function(accumulator!)
        }
        break
      case .binaryOperation(let function):
        if accumulator != nil {
          pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
          accumulator = nil
        }
        break
      case .equals:
        performPendingBindaryOperation()
        break
      }
    
    }
  }
  
  private mutating func performPendingBindaryOperation(){
    if pendingBinaryOperation != nil && accumulator != nil{
      accumulator = pendingBinaryOperation?.perform(with: accumulator!)
      pendingBinaryOperation = nil
    }
  }
  
  mutating func setOperand(_ operand: Double) {
    accumulator = operand
  }
  
  
}
