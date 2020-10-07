//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Taha Afzal on 10/6/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    // to implement pull to refresh
    let pullToRefresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        pullToRefresh.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = pullToRefresh
    }
    
    @objc func loadTweet() {
        let tweetsAPI = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsAPI, parameters: params,
        success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            // to stop the spinning wheel from infinitely spinning after we refresh once
            self.pullToRefresh.endRefreshing()
        },
        failure: { (Error) in
            print(Error.localizedDescription)
        })
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        // setting the image
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        // setting the username and Tweet content
        cell.usernameLabel.text = user["name"] as? String ?? "username not available"
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String ?? "Tweet content not available"
        
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }

}
