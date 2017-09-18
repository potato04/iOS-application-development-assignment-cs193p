//
//  TweetImageScrollViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/6.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit

class TweetImageScrollViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
  
  var image: UIImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    imageView.image = image
    imageView.sizeToFit()
    scrollView?.contentSize = imageView.frame.size
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateMinZoomScaleForSize(view.bounds.size)
  }
  
  fileprivate func updateMinZoomScaleForSize(_ size: CGSize){
    let widthScale = size.width / imageView.bounds.width
    let heightScale = size.height / imageView.bounds.height
    let minScale = min(widthScale, heightScale)
    scrollView.minimumZoomScale = minScale
    scrollView.zoomScale = 1
  }
  
}

extension TweetImageScrollViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
