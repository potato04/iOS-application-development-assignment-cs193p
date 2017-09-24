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
    updateDatabase(with: newTweets)
  }
  
  private func updateDatabase(with tweets: [Twitter.Tweet]) {
    print("starting databse load")
    container?.performBackgroundTask{ [weak self] context in
//      for twitterInfo in tweets {
//       _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, with: (self?.searchText)!, in: context)
//      }
      
      _ = try? Tweet.findOrCreateTweets(matching: tweets, with: (self?.searchText)!, in: context)
      try? context.save()
      print("done loading database")
      self?.printDatabaseStatistics()
    }
  }
  private func printDatabaseStatistics() {
    if let context = container?.viewContext {
      context.perform {
        if Thread.isMainThread {
          print("on main thread")
        } else {
          print("off main thread")
        }
        // bad way to count
        if let tweetCount = (try? context.fetch(Tweet.fetchRequest() as NSFetchRequest<Tweet>))?.count {
          print("\(tweetCount) tweets")
        }
        // good way to count
        if let mentionsCount = try? context.count(for: Mention.fetchRequest()) {
          print("\(mentionsCount) mentions")
        }
      }
    }
  }
}
