//
//  TweetImagesCollectionViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/14.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "TweetImageCollectionViewCell"

class TweetImagesCollectionViewController: UICollectionViewController {
  
  fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
  fileprivate let itemsPerRow: CGFloat = 3
  
  private var tweets = [Array<Twitter.Tweet>](){
    didSet {
      print(tweets)
    }
  }
  
  var searchText: String? {
    didSet {
      searchTextField?.text = searchText
      searchTextField?.resignFirstResponder()
      lastTwitterRequest = nil
      tweets.removeAll()
      collectionView?.reloadData()
      searchForTweets()
      title = searchText
      RecentSearchTermsStore.sharedStore.addTerms(term: searchText)
    }
  }
  
  let refreshControl = UIRefreshControl()

  private func twitterRequest() -> Twitter.Request? {
    if let query = searchText, !query.isEmpty {
      //return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count:100)
      return Twitter.Request(search: "\(query) filter:media", count:50)
    }
    return nil
  }
  
  private var lastTwitterRequest: Twitter.Request?
  
  @objc private func searchForTweets(){
    if let request = lastTwitterRequest?.newer ?? twitterRequest() {
      lastTwitterRequest = request
      request.fetchTweets{ [weak self] newTweets in
        let imageTweets = newTweets.filter({$0.media.first != nil})
        DispatchQueue.main.async {
          if request == self?.lastTwitterRequest {
            self?.tweets.insert(imageTweets, at: 0)
            DispatchQueue.main.async {
              //self?.tableView.insertSections([0], with: .fade)
              self?.collectionView?.insertSections([0])
            }
          }
          self?.refreshControl.endRefreshing()
        }
      }
    }
  }
  
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.text = searchText
      searchTextField.delegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Register cell classes
    //self.collectionView!.register(TweetImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    // Do any additional setup after loading the view.
    
    refreshControl.addTarget(self, action: #selector(searchForTweets), for: .valueChanged)
    collectionView?.addSubview(refreshControl)
    collectionView?.alwaysBounceVertical = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using [segue destinationViewController].
   // Pass the selected object to the new view controller.
   }
   */
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return tweets.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return tweets[section].count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetImageCollectionViewCell
    
    // Configure the cell
    cell.backgroundColor = UIColor.white
    let tweet = tweets[indexPath.section][indexPath.row]
    if let media = tweet.media.first {
      cell.mediaItem = media
    }
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTweet" {
      let destController = segue.destination as! TweetTableViewController
      let cell = sender as! UICollectionViewCell
      let indexPath = self.collectionView!.indexPath(for: cell)!
      let tweet = tweets[indexPath.section][indexPath.row]
      destController.tweets = [[tweet]]
    }
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
}

extension TweetImagesCollectionViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == searchTextField {
      searchText = searchTextField.text
    }
    return true
  }
}
extension TweetImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
