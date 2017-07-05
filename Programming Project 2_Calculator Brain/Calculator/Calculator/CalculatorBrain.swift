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
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double,Double) -> Double)
		case equals
	}
	
	private var commands = [(operation:Operation, description:String)]()
	
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
		"=" : Operation.equals
	]
	
	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			commands.append((operation, symbol))
		}
	}
	mutating func setOperand(_ operand: Double) {
		commands.append((Operation.number(operand),String(operand)))
	}
	
	mutating func setOperand(variable named: String) {
		commands.append((Operation.variable(named), named))
	}
	
	mutating func	undoOperation(){
		commands.removeLast(1)
	}
	
	func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
		
		var result: (accumulator: Double?, description: String) = (nil, " ")
		var pendingBinaryOperation: PendingBinaryOperation?

		struct PendingBinaryOperation {
			let function: (Double,Double) -> Double
			let firstOperand: Double
			
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
				result = (number, resultIsPending ? result.description : command.description)
			
			case .variable(let named):
				dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
				result = (variables?[named] ?? 0 , result.description + command.description)
				break
				
			case .constant(let value):
				dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
				result = (value, result.description + command.description)
			
			case .unaryOperation(let function):
				if let accumulator = result.accumulator {
					if resultIsPending {
						result = (function(accumulator), result.description + command.description + String(accumulator))
						dontAppendingAccmulatorWhenPerformPendingBinaryOperation = true
					} else {
						result = (function(accumulator), command.description + "(\(result.description))")
					}
				}
				
			case .binaryOperation(let function):
				if result.accumulator != nil {
					if resultIsPending {
						performPendingBinaryOperation()
					}
					pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: result.accumulator!)
					result = (nil, result.description == " " ? String(result.accumulator!) + command.description : result.description + command.description )
				}
				
			case .equals:
				performPendingBinaryOperation()
			
			}
		}
		
		func performPendingBinaryOperation(){
			if resultIsPending, let accumulator = result.accumulator {
				result = (pendingBinaryOperation?.perform(with: accumulator),
				          dontAppendingAccmulatorWhenPerformPendingBinaryOperation == true ? result.description : result.description + String(accumulator))
				dontAppendingAccmulatorWhenPerformPendingBinaryOperation = false
				pendingBinaryOperation = nil
			}
		}
		
		for command in commands {
			performOperation(command: command)
		}
		
		return (result.accumulator, resultIsPending, result.description)
	}
	
	
}
