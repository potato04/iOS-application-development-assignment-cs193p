//
//  Tweet.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/20.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
  class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, with searchTerm: String, in context: NSManagedObjectContext) throws -> Tweet {
    let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
    request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
    
    do {
      let matches = try context.fetch(request)
      if matches.count > 0 {
        assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
        return matches[0]
      }
      
      let tweet = Tweet(context: context)
      tweet.unique = twitterInfo.identifier
      tweet.text = twitterInfo.text
      tweet.created = twitterInfo.created as NSDate
      
      // check mentions
      for hasttag in twitterInfo.hashtags {
        _ = try? Mention.findOrCreateMention(for: tweet, withKeyword: hasttag.keyword, andSearchTerm: searchTerm, andType: "Hashtags", in: context)
      }
      for user in twitterInfo.userMentions {
        _ = try? Mention.findOrCreateMention(for: tweet, withKeyword: user.keyword, andSearchTerm: searchTerm, andType: "Users", in: context)
      }
      return tweet
    } catch {
      throw error
    }
  }
}
