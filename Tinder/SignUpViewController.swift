//
//  SignUpViewController.swift
//  Tinder
//
//  Created by Rommel Rico on 3/15/15.
//  Copyright (c) 2015 Appfish. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myGenderSwitch: UISwitch!
    
    @IBAction func doSignUp(sender: AnyObject) {
        var user = PFUser.currentUser()
        if myGenderSwitch.on {
            //Looking for Women
            user["interestedIn"] = "female"
        } else {
            //Looking for Men.
            user["interestedIn"] = "male"
        }
        user.saveInBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser()
        
        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            //Get Image Information
            let image = UIImage(data: data)
            self.myImageView.image = image
            user["image"] = data
            user.saveInBackground()
            
            //Get Gender Information
            FBRequestConnection.startForMeWithCompletionHandler({ (connection, result, error) -> Void in
                user["gender"] = result["gender"]
                user["name"] = result["name"]
                user.saveInBackground()
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
