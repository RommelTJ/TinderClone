//
//  TinderViewController.swift
//  Tinder
//
//  Created by Rommel Rico on 3/15/15.
//  Copyright (c) 2015 Appfish. All rights reserved.
//

import UIKit


class TinderViewController: UIViewController {
    var xFromCenter:CGFloat = 0
    var usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                NSLog("My Point: \(geopoint)")
                var user = PFUser.currentUser()
                user["location"] = geopoint
                
                // Create a query for places
                var query = PFUser.query()
                // Interested in locations near user.
                query.whereKey("location", nearGeoPoint:geopoint)
                // Limit what could be a lot of points.
                query.limit = 10
                // Final list of objects
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    for user in users {
                        var gender1 = user["gender"]! as? NSString
                        var gender2 = PFUser.currentUser()["interestedIn"]! as? NSString
                        
                        if (gender1 == gender2) && (PFUser.currentUser().username != user.username) {
                            NSLog("here1")
                            self.usernames.append(user.username)
                            NSLog("here2")
                            self.userImages.append(user["image"] as NSData)
                            NSLog("here3")
                        }
                    }
                    
                    //Creating an Image programmatically
                    NSLog("Here4")
                    var image:UIImageView = UIImageView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
                    image.image = UIImage(data: self.userImages[0])
                    image.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(image)
                    
                    //Making the label draggable
                    var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                    image.addGestureRecognizer(gesture)
                    image.userInteractionEnabled = true

                })
                
                user.saveInBackground()
            }
        }
        
    }
    
    func wasDragged(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        xFromCenter += translation.x
        var scale = min(100 / abs(xFromCenter), 1)
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        //Rotation and Scaling
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        //Check if the label is to the left or right
        if (label.center.x < 100) {
            NSLog("Not chosen!")
        } else if (label.center.x > self.view.bounds.width-100) {
            NSLog("Chosen")
        }
        
        //Reset label
        if (gesture.state == UIGestureRecognizerState.Ended) {
            currentUser++
            label.removeFromSuperview()
            
            if currentUser < userImages.count {
                //Creating an Image programmatically
                var image:UIImageView = UIImageView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
                image.image = UIImage(data: self.userImages[currentUser])
                image.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(image)
                
                //Making the label draggable
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                image.addGestureRecognizer(gesture)
                image.userInteractionEnabled = true
                
                xFromCenter = 0
            } else {
                NSLog("No More Users")
            }
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
