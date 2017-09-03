//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/8/29.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
  
  var tweet: Twitter.Tweet! {
    didSet {
      items = [
        0: ["Images" : [Item]()],
        1: ["Hashtags" : [Item]()],
        2: ["Users" : [Item]()],
        3: ["Urls" : [Item]()],
      ]
      for media in tweet.media {
        items[0]?["Images"]?.append(Item.Image(media))
      }
      for hashtag in tweet.hashtags {
        items[1]?["Hashtags"]?.append(.Mention(hashtag.keyword))
      }
      for user in tweet.userMentions {
        items[2]?["Users"]?.append(.Mention(user.keyword))
      }
      for url in tweet.urls {
        items[3]?["Urls"]?.append(.Mention(url.keyword))
      }
      title = tweet.user.name
    }
  }
  
  private var items: [Int: [String : [Item]]] = [:]
  
  private enum Item {
    case Image(MediaItem)
    case Mention(String)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName:"TweetDetailImageTableViewCell", bundle:nil), forCellReuseIdentifier: "ImageTableViewCell")
    //    tableView.estimatedRowHeight = tableView.rowHeight
    //    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (items[section]?.first?.value.count)!
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = (items[indexPath.section]?.first?.value[indexPath.row])!
    switch item {
    case .Image(let mediaItem):
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! TweetDetailImageTableViewCell
      cell.mediaItem = mediaItem
      return cell
    case .Mention(let keyword):
      var cell = tableView.dequeueReusableCell(withIdentifier: "MetionsTableViewCell")
      if cell == nil {
        cell = UITableViewCell(style: .default, reuseIdentifier: "MetionsTableViewCell")
      }
      cell?.textLabel?.text = keyword
      return cell!
    }
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let item = (items[indexPath.section]?.first?.value[indexPath.row])!
    switch item {
    case .Image(let mediaItem):
      return self.tableView.bounds.width / CGFloat(mediaItem.aspectRatio)
    default:
      return UITableViewAutomaticDimension
    }
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
      return items[section]?.first?.key
    }
    return nil
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
