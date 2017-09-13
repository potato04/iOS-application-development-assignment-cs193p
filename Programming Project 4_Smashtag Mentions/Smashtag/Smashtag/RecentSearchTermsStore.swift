//
//  RecentSearchTermsStore.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/8.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import Foundation

class RecentSearchTermsStore {
  
  static let sharedStore = RecentSearchTermsStore()
  
  private(set) var recentSearchTerms: [String] = []
  
  private init() {
    if let terms = UserDefaults.standard.object(forKey: "RecentSearchTermsStore") as? [String] {
      recentSearchTerms = terms
    }
  }
  
  func addTerms(term: String?) {
    guard let _ = term else {
      return
    }
    recentSearchTerms.insert(term!, at: 0)
    if recentSearchTerms.count > 100 {
      recentSearchTerms.removeLast()
    }
    UserDefaults.standard.set(recentSearchTerms, forKey: "RecentSearchTermsStore")
  }
  func removeTerms(index: Int) {
    if index < 0 {
      return
    }
    recentSearchTerms.remove(at: index)
    UserDefaults.standard.set(recentSearchTerms, forKey: "RecentSearchTermsStore")
  }
  
}
