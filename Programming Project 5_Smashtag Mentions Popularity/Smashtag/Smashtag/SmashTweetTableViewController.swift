//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/19.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
  
  var container: NSPersistentContainer? =
    (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
  
  override func insertTweets(_ newTweets: [Twitter.Tweet]) {
    super.insertTweets(newTweets)
  }
  
  private func updateDatabase(with tweets: [Twitter.Tweet]) {
    print("starting databse load")
    container?.performBackgroundTask{ [weak self] context in
      for twitterInfo in tweets {
        //TODO
      }
      try? context.save()
      print("done loading database")
      self?.printDatabaseStatistics()
    }
  }
  private func printDatabaseStatistics() {
    
  }
}
