//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/8/26.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
  
  @IBOutlet weak var tweetProfileImageView: UIImageView!
  @IBOutlet weak var tweetCreatedLabel: UILabel!
  @IBOutlet weak var tweetUserLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  var tweet: Twitter.Tweet? {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    if let item = tweet {
      let tweetText = NSMutableAttributedString(string: item.text)
      for hashtag in item.hashtags {
        if hashtag.nsrange.location != NSNotFound {
          tweetText.addAttributes([NSForegroundColorAttributeName : UIColor.blue], range: hashtag.nsrange)
        }
      }
      for url in item.urls {
        if url.nsrange.location != NSNotFound {
          tweetText.addAttributes([NSForegroundColorAttributeName : UIColor.purple], range: url.nsrange)
        }
      }
      for mention in item.userMentions {
        if mention.nsrange.location != NSNotFound {
          tweetText.addAttributes([NSForegroundColorAttributeName : UIColor.brown], range: mention.nsrange)
        }
      }
      tweetTextLabel.attributedText = tweetText
    }
    tweetUserLabel.text = tweet?.user.description
    
    if let profileImageURL = tweet?.user.profileImageURL {
      //FIXME: blocks main thread
      if let imageData = try? Data(contentsOf: profileImageURL) {
        tweetProfileImageView.image = UIImage(data: imageData)
      }
    } else {
      tweetProfileImageView.image = nil
    }
    
    if let created = tweet?.created {
      let formatter = DateFormatter()
      if Date().timeIntervalSince(created) > 24*60*60 {
        formatter.dateStyle = .short
      } else {
        formatter.timeStyle = .short
      }
      tweetCreatedLabel.text = formatter.string(from: created)
    } else {
      tweetCreatedLabel.text = nil
    }
  }

}
