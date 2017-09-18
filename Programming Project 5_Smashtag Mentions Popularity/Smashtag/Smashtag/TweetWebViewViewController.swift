//
//  TweetWebViewViewController.swift
//  Smashtag
//
//  Created by shiwangwang on 2017/9/11.
//  Copyright © 2017年 shiwangwang. All rights reserved.
//

import UIKit

class TweetWebViewViewController: UIViewController {
  
  @IBOutlet weak var webView: UIWebView! {
    didSet {
      let url = URL(string: self.url)
      webView.loadRequest(URLRequest(url: url!))
    }
  }
  var url: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let goBackButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(goBack))
    self.setToolbarItems([goBackButton], animated: false)
    self.navigationController?.setToolbarHidden(false, animated: false)
    automaticallyAdjustsScrollViewInsets = false
    // Do any additional setup after loading the view.
  }
  
  func goBack() {
//    self.navigationController?.popViewController(animated: true)
    self.webView.goBack()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setToolbarHidden(true, animated: false)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
