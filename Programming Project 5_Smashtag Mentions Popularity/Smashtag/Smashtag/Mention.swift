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
  class func findOrCreateMention(for tweet: Tweet, withKeyword keyword: String, andSearchTerm searchTerm: String, andType  type: String, in context: NSManagedObjectContext) throws -> Mention {
    let request: NSFetchRequest<Mention> = Mention.fetchRequest()
    request.predicate = NSPredicate(format: "keyword =[cd] %@ AND searchTerm =[cd] %@ AND type =[cd] %@",keyword,searchTerm,type)
    
    do {
      let matches = try context.fetch(request)
      if matches.count > 0 {
        assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
        return matches[0]
      }
    } catch {
      throw error
    }
    
    let mention = Mention(context: context)
    mention.keyword = keyword
    mention.searchTerm = searchTerm
    mention.type = type
    mention.tweet = tweet

    return mention
  }
}
