//
//  SmashPopularityTableViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/21.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit
import CoreData

class SmashPopularityTableViewController: FetchedResultsTableViewController {
  var searchTerm: String? { didSet { updateUI() } }
  
  var container: NSPersistentContainer? =
    (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    { didSet { updateUI() } }
  
  var fetchedResultsController: NSFetchedResultsController<Mention>?
  
  private func updateUI() {
    if let context = container?.viewContext, searchTerm != nil {
      let request: NSFetchRequest<Mention> = Mention.fetchRequest()
      request.predicate = NSPredicate(format: "searchTerm = %@ AND count > 1", searchTerm!)
      request.sortDescriptors = [
        NSSortDescriptor(key: "count", ascending: false),
        NSSortDescriptor(key: "keyword", ascending: true,selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
      ]
      
      fetchedResultsController = NSFetchedResultsController<Mention>(
        fetchRequest: request,
        managedObjectContext: context,
        sectionNameKeyPath: nil,
        cacheName: nil
      )
      fetchedResultsController?.delegate = self
      try? fetchedResultsController?.performFetch()
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SmashPopularityTableViewCell", for: indexPath)
    if let mention = fetchedResultsController?.object(at: indexPath) {
      cell.textLabel?.text = mention.keyword
      cell.detailTextLabel?.text = "\(mention.count) tweets"
    }
    return cell
  }
}
