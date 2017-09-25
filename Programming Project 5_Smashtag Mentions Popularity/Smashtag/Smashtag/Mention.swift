//
//  Mention.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/20.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Mention: NSManagedObject {
  class func initOrIncrementMentionCount(for tweet: Tweet, withKeyword keyword: String, andSearchTerm searchTerm: String, andType  type: String, in context: NSManagedObjectContext) throws -> Mention {
    let request: NSFetchRequest<Mention> = Mention.fetchRequest()
    request.predicate = NSPredicate(format: "keyword =[cd] %@ AND searchTerm =[cd] %@ AND type =[cd] %@", keyword, searchTerm, type)
    
    do {
      let matches = try context.fetch(request)
      if matches.count > 0 {
        assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
        
        if !(matches[0].tweets?.contains(tweet))! {
          matches[0].count = matches[0].count + 1
          matches[0].addToTweets(tweet)
        }
        return matches[0]
      }
    } catch {
      throw error
    }
    
    let mention = Mention(context: context)
    mention.keyword = keyword
    mention.searchTerm = searchTerm
    mention.type = type
    mention.addToTweets(tweet)
    mention.count = 1
    
    return mention
  }
  class func deleteAllMentions(exclude searchTerm: [String], in context: NSManagedObjectContext){
    let request: NSFetchRequest<Mention> = Mention.fetchRequest()
    request.predicate = NSPredicate(format: "NOT( searchTerm IN %@)", searchTerm)
    do {
      if let mentions = try? context.fetch(request) {
        for mention in mentions {
          context.delete(mention)
        }
        try? context.save()
      }
    }
  }
}
