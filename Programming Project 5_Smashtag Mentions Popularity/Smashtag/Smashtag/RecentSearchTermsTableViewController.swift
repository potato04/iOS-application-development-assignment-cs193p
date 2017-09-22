//
//  RecentSearchTermsTableViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/8.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit

class RecentSearchTermsTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return RecentSearchTermsStore.sharedStore.recentSearchTerms.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath)
    cell.textLabel?.text = RecentSearchTermsStore.sharedStore.recentSearchTerms[indexPath.row]
    return cell
  }
  
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      RecentSearchTermsStore.sharedStore.removeTerms(index: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier, identifier == "ShowSmashPopularityTableView",
      let cell = sender as? UITableViewCell,
      let tweetersTVC = segue.destination as? SmashPopularityTableViewController {
      tweetersTVC.searchTerm = cell.textLabel?.text
    }
  }
}
