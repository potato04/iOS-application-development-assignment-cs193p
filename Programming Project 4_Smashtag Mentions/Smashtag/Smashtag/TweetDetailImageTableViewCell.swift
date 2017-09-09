//
//  TweetDetailImageTableViewCell.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/8/29.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailImageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var tweetImage: UIImageView!
  
  var mediaItem: MediaItem? {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    if let image = mediaItem {
      print("url:\(image.url) AspectRatio:\(image.aspectRatio)")
      //FIXME: blocks main thread
      DispatchQueue.global(qos: .userInitiated).async {
        [weak self] in
        if let imageData = try? Data(contentsOf: image.url) {
          DispatchQueue.main.async {
            self?.tweetImage.image = UIImage(data: imageData)
          }
        }
      }
    }
  }
}
