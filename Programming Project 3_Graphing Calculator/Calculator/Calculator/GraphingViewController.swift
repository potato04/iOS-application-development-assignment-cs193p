//
//  GraphingViewController.swift
//  Calculator
//
//  Created by shiwangwang on 2017/8/3.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit

class GraphingViewController: UIViewController {
  
  var calcFunction: ((Double) -> Double?)?
  var functionDescription: String = ""
  @IBOutlet weak var graphingView: GraphingView!{
    didSet {
      graphingView.dataSource = self
      let handler = #selector(GraphingView.pan(byReactingTo:))
      let panRegnizer = UIPanGestureRecognizer(target: graphingView, action: handler)
      graphingView.addGestureRecognizer(panRegnizer)
    }
  }

  override func viewDidLoad() {
    
  }
}

extension GraphingViewController: GraphingViewDataSource{
  func graphingView(_ graphingView: GraphingView, xAxisValue: Double) -> Double? {
    if let getYValue = calcFunction {
        return getYValue(xAxisValue)
    }
    return nil
  }
}
