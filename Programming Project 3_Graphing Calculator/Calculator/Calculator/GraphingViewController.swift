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
    }
  }

  override func viewDidLoad() {
    
  }
}

extension GraphingViewController: GraphingViewDataSource{
  func graphingView(_ graphingView: GraphingView, xAxisValue: Double) -> Double? {
    return calcFunction!(xAxisValue)
  }
  func functiontDescription(_ graphingView: GraphingView) -> String {
    return functionDescription
  }
}
