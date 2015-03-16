//
//  TinderViewController.swift
//  Tinder
//
//  Created by Rommel Rico on 3/15/15.
//  Copyright (c) 2015 Appfish. All rights reserved.
//

import UIKit


class TinderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("In View Did Load")
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            NSLog("In PFGeoPoint")
            if error == nil {
                NSLog("My Point: \(geopoint)")
                var user = PFUser.currentUser()
                user["location"] = geopoint
                user.saveInBackground()
            }
        }
        
        var i = 0.10
        
        func addPerson(urlString:String) {
            var newUser = PFUser()
            let url = NSURL(string: urlString)
            let urlRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                //Get Image Information
                newUser["image"] = data
                newUser["gender"] = "Female"
                var lat = Double(32+i)
                var lon = Double(-117+i)
                i = i + 10
                var location = PFGeoPoint(latitude: lat, longitude: lon)
                newUser["location"] = location
                newUser.username = "\(i)"
                newUser.password = "password"
                newUser.signUp()
            }
            
        }
        
        addPerson("http://s3.amazonaws.com/readers/2010/12/07/3186885154021fda16b1_1.jpg")
        
        addPerson("http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840")
        addPerson("http://static.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG")
        addPerson("http://i263.photobucket.com/albums/ii139/whatgloom/janejetson.jpg")
        addPerson("http://www.scrapwallpaper.com/wp-content/uploads/2014/08/female-cartoon-characters-pictures-6.jpg")
        addPerson("http://diaryofalagosmumblog.files.wordpress.com/2011/11/smurfette-scaled500.gif")
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
