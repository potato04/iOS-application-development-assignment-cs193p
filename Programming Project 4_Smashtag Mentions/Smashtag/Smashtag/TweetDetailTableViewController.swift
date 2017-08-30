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
  
  var tweet: Twitter.Tweet!
  var sectinType:[String] = ["Images","Hashtags","Users","Urls"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName:"TweetDetailImageTableViewCell", bundle:nil), forCellReuseIdentifier: "ImageTableViewCell")
//    tableView.estimatedRowHeight = tableView.rowHeight
//    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: //images
      return tweet.media.count
    case 1: //hashtags
      return tweet.hashtags.count
    case 2: //users
      return tweet.userMentions.count
    case 3: //urls
      return tweet.urls.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: //images
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath)
      if let imageCell = cell as? TweetDetailImageTableViewCell {
        imageCell.mediaItem = tweet.media[indexPath.row]
      }
      return cell
    case 1://hashtags
      var cell = tableView.dequeueReusableCell(withIdentifier: "MetionsTableViewCell")
      if cell == nil{
        cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MetionsTableViewCell")
      }
      cell?.textLabel?.text = tweet.hashtags[indexPath.row].keyword
      return cell!
    case 2://users
      var cell = tableView.dequeueReusableCell(withIdentifier: "MetionsTableViewCell")
      if cell == nil{
        cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MetionsTableViewCell")
      }
      cell?.textLabel?.text = tweet.userMentions[indexPath.row].keyword
      return cell!
    case 3://urls
      var cell = tableView.dequeueReusableCell(withIdentifier: "MetionsTableViewCell")
      if cell == nil{
        cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MetionsTableViewCell")
      }
      cell?.textLabel?.text = tweet.urls[indexPath.row].keyword
      return cell!
    default:
      return UITableViewCell()
    }
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return self.tableView.bounds.width / CGFloat(tweet.media[indexPath.row].aspectRatio)
    } else {
      return UITableViewAutomaticDimension
    }
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
      return sectinType[section]
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
