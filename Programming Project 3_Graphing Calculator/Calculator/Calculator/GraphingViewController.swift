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
  @IBOutlet weak var graphingView: GraphingView!{
    didSet {
      graphingView.dataSource = self
      
      let panRecognizer = UIPanGestureRecognizer(target: graphingView, action: #selector(GraphingView.pan(byReactingTo:)))
      graphingView.addGestureRecognizer(panRecognizer)
      
      let pinchRecognizer = UIPinchGestureRecognizer(target: graphingView, action:#selector(GraphingView.pinch(byReactingTo:)))
      graphingView.addGestureRecognizer(pinchRecognizer)
      
      let doubleTapRecognizer = UITapGestureRecognizer(target: graphingView, action: #selector(GraphingView.doubleTap(byReactingTo:)))
      doubleTapRecognizer.numberOfTapsRequired = 2
      graphingView.addGestureRecognizer(doubleTapRecognizer)
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
