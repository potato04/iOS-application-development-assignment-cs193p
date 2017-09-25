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
        _ = try? Mention.initOrIncrementMentionCount(for: tweet, withKeyword: hasttag.keyword, andSearchTerm: searchTerm, andType: "Hashtags", in: context)
      }
      for user in twitterInfo.userMentions {
        _ = try? Mention.initOrIncrementMentionCount(for: tweet, withKeyword: user.keyword, andSearchTerm: searchTerm, andType: "Users", in: context)
      }
      return tweet
    } catch {
      throw error
    }
  }
  class func findOrCreateTweets(matching tweets: [Twitter.Tweet], with searchTerm: String, in context: NSManagedObjectContext) throws -> [Tweet] {
    let identifiers = tweets.map{return $0.identifier}
    let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
    request.predicate = NSPredicate(format: "unique IN %@ AND ANY mentions.searchTerm = %@", identifiers, searchTerm)
    do {
      var newTweets = [Tweet]()
      let existsTweets = try context.fetch(request)
      let existsIdentifiers = Set(existsTweets.flatMap{$0.unique})
      let newIdentifiers = Set(identifiers).subtracting(existsIdentifiers)
      for identifier in newIdentifiers {
        if let twitterInfo = (tweets.filter{$0.identifier == identifier}).first {
          let tweet = Tweet(context: context)
          tweet.unique = twitterInfo.identifier
          tweet.text = twitterInfo.text
          tweet.created = twitterInfo.created as NSDate
          // check mentions
          for hasttag in twitterInfo.hashtags {
            _ = try? Mention.initOrIncrementMentionCount(for: tweet, withKeyword: hasttag.keyword, andSearchTerm: searchTerm, andType: "Hashtags", in: context)
          }
          for user in twitterInfo.userMentions {
            _ = try? Mention.initOrIncrementMentionCount(for: tweet, withKeyword: user.keyword, andSearchTerm: searchTerm, andType: "Users", in: context)
          }
          newTweets.append(tweet)
        }
      }
      return newTweets
    } catch {
      throw error
    }
  }
  class func deleteAllTweetsWhichHaveNoMention(in context: NSManagedObjectContext){
    let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
    request.predicate = NSPredicate(format: "mentions.@count == 0")
    do {
      if let tweets = try? context.fetch(request) {
        for tweet in tweets {
          context.delete(tweet)
        }
        try? context.save()
      }
    }
  }
}
