//
//  GraphingView.swift
//  Calculator
//
//  Created by shiwangwang on 2017/8/4.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit

protocol GraphingViewDataSource{
  func graphingView(_ graphingView: GraphingView, xAxisValue: Double) -> Double?
  func functiontDescription(_ graphingView: GraphingView) -> String
}


class GraphingView: UIView {
  
  var color: UIColor = UIColor.blue
  var axesDrawer: AxesDrawer = AxesDrawer()
  var pointsPerUnit: CGFloat = 50
  
  var graphOrigin: CGPoint!
  var dataSource: GraphingViewDataSource?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    graphOrigin = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    graphOrigin = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
  }
  
  override func draw(_ rect: CGRect) {
    axesDrawer.drawAxes(in: rect, origin: graphOrigin, pointsPerUnit: pointsPerUnit)
    
    if let source = dataSource {
      for x in stride(from: rect.minX, to: rect.maxX, by: 1){
        let xAxisValue = (x-graphOrigin.x)/pointsPerUnit
        if let yAxisValue = source.graphingView(self, xAxisValue: Double(xAxisValue)) {
           let position = transformToViewCoordinate(xy: (x: xAxisValue, y: CGFloat(yAxisValue)))
          UIRectFill(CGRect(x: position.x, y: position.y, width: 1, height: 1))
        }
      }
    }
  }
  
  private func transformToViewCoordinate(xy:(x:CGFloat,y:CGFloat)) -> CGPoint{
    return CGPoint(x: graphOrigin.x + (xy.x * pointsPerUnit),
                   y: graphOrigin.y - (xy.y * pointsPerUnit))
  }
}
