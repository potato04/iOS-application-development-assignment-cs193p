//
//  GraphingViewController.swift
//  Calculator
//
//  Created by shiwangwang on 2017/8/3.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit

class GraphingViewController: UIViewController {
  
  @IBOutlet weak var graphingView: GraphingView!
  
  override func viewDidLoad() {
    graphingView.dataSource = self
  }

}

extension GraphingViewController: GraphingViewDataSource{
  func graphingView(_ graphingView: GraphingView, xAxisValue: Double) -> Double? {
    return xAxisValue + 1
  }
  func functiontDescription(_ graphingView: GraphingView) -> String {
    return "y=sin(x)"
  }
}
