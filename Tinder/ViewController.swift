//
//  ViewController.swift
//  Tinder
//
//  Created by Rob Percival on 02/09/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myLoginCancelledLabel: UILabel!
    
    var fbLoginView:FBLoginView = FBLoginView(readPermissions: ["public_profile"])
    
    @IBAction func doSignIn(sender: AnyObject) {
        var permissions = ["public_profile"]

        self.myLoginCancelledLabel.alpha = 0
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                self.myLoginCancelledLabel.alpha = 1
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                self.performSegueWithIdentifier("signUp", sender: self)
            } else {
                NSLog("User logged in through Facebook!")
                //TODO
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if PFUser.currentUser() != nil {
            NSLog("User is logged in")
        }
        
//        var push = PFPush()
//        push.setMessage("Hello Notification!")
//        push.sendPushInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
//            if error == nil {
//                NSLog("We were succesful!")
//            }
//        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

