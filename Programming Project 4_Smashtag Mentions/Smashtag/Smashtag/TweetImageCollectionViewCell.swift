//
//  TweetImageCollectionViewCell.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/14.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import Twitter

class TweetImageCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  var mediaItem: MediaItem? {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    if let image = mediaItem {
      DispatchQueue.global(qos: .userInitiated).async {
        [weak self] in
        if let imageData = try? Data(contentsOf: image.url) {
          DispatchQueue.main.async {
            self?.imageView.image = UIImage(data: imageData)
          }
        }
      }
    }
  }
}
