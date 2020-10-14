//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Taha Afzal on 10/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    @IBOutlet weak var tweetTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetText: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                print(Error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
