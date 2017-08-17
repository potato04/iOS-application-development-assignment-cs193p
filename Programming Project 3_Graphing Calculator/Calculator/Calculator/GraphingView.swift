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
}

@IBDesignable
class GraphingView: UIView {
  
  var color: UIColor = UIColor.red
  var axesDrawer: AxesDrawer = AxesDrawer()
  
  @IBInspectable
  var scale: CGFloat = 1 {
    didSet {
      UserDefaults.standard.set(scale, forKey: "scale")
      setNeedsDisplay()
    }
  }
  
  var pointsPerUnit: CGFloat {
    return 50 * scale
  }
  
  var graphOrigin: CGPoint! {
    didSet{
      UserDefaults.standard.set(graphOrigin.x, forKey: "originX")
      UserDefaults.standard.set(graphOrigin.y, forKey: "originY")
      setNeedsDisplay()
    }
  }
  var dataSource: GraphingViewDataSource?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initScaleAndOrigin()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initScaleAndOrigin()
  }
  
  override func prepareForInterfaceBuilder() {
    initScaleAndOrigin()
  }
  private func initScaleAndOrigin(){
    if let defaultOriginX = UserDefaults.standard.object(forKey: "originX"), defaultOriginX is CGFloat,
      let defaultOriginY = UserDefaults.standard.object(forKey: "originY"), defaultOriginY is CGFloat{
      graphOrigin = CGPoint(x: defaultOriginX as! CGFloat, y: defaultOriginY as! CGFloat)
    }
    else {
      graphOrigin = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
    if let defaultScale = UserDefaults.standard.object(forKey: "scale"), defaultScale is CGFloat{
      scale = defaultScale as! CGFloat
    }
  }
  override func draw(_ rect: CGRect) {
    //save scale and graphOrigin
    
    //draw axes
    axesDrawer.drawAxes(in: rect, origin: graphOrigin, pointsPerUnit: pointsPerUnit)
    //draw graph
    if let source = dataSource {
      let path = UIBezierPath()
      
      for x in stride(from: rect.minX, to: rect.maxX, by: 1){
        let xAxisValue = (x-graphOrigin.x)/pointsPerUnit
        if let yAxisValue = source.graphingView(self, xAxisValue: Double(xAxisValue)) {
           let position = transformToViewCoordinate(xy: (x: xAxisValue, y: CGFloat(yAxisValue)))
          if x == rect.minX {
            path.move(to: CGPoint(x: position.x, y: position.y))
          }else {
            path.addLine(to: CGPoint(x: position.x, y: position.y))
          }
        }
      }
      color.setStroke()
      path.lineWidth = 1.0
      path.stroke()
    }
  }
  
  private func transformToViewCoordinate(xy:(x:CGFloat,y:CGFloat)) -> CGPoint{
    return CGPoint(x: graphOrigin.x + (xy.x * pointsPerUnit),
                   y: graphOrigin.y - (xy.y * pointsPerUnit))
  }
  
  func pan(byReactingTo panRecognizer: UIPanGestureRecognizer) {
    switch panRecognizer.state {
    case .changed: fallthrough
    case .ended:
      let translation = panRecognizer.translation(in: self)
      if translation.x != 0 || translation.y != 0 {
        let newGraphOrigin = CGPoint(x: graphOrigin.x + translation.x, y: graphOrigin.y + translation.y)
        graphOrigin = newGraphOrigin
      }
      panRecognizer.setTranslation(CGPoint.zero, in: self)
    default: break
    }
  }
  func pinch(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
    switch pinchRecognizer.state {
    case .changed: fallthrough
    case .ended:
      scale *= pinchRecognizer.scale
      pinchRecognizer.scale = 1
    default: break
    }
  }
  func doubleTap(byReactingTo tapRecognizer: UITapGestureRecognizer) {
    switch tapRecognizer.state {
    case .changed: fallthrough
    case .ended:
     graphOrigin = tapRecognizer.location(in: self)
    default: break
    }
  }
  
}
