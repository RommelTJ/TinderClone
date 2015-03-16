//
//  ViewController.swift
//  Tinder
//
//  Created by Rob Percival on 02/09/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var push = PFPush()
        push.setMessage("Hello Notification!")
        push.sendPushInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
            if error == nil {
                NSLog("We were succesful!")
            }
        }
        
        var permissions = ["public_profile"]
        
        // Update - added , block:
        
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
            } else {
                NSLog("User logged in through Facebook!")
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

