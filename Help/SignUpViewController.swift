//
//  SignUpViewController.swift
//  Help
//
//  Created by LiQihui on 11/27/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit
import Foundation

protocol SignUpControllerDelegate{
    func myVCDidFinish(controller:SignUpViewController,Name:String,Password:String,FriendList:[String])
}

class SignUpViewController:
   
    UIViewController, FBLoginViewDelegate {
    @IBOutlet var PasswordTextField: UITextField!
    
    @IBOutlet var fbProfilePictureView: FBProfilePictureView!
    @IBOutlet var signUpView: UIView!
    @IBOutlet var NameTextField: UITextField!
     var tap: UITapGestureRecognizer!
    @IBOutlet var fbLoginView: FBLoginView!
    @IBOutlet var EmailTextField: UITextField!
    var friendList: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordTextField.secureTextEntry = true
        // Do any additional setup after loading the view.
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        //Tap Gesture Recognizer
        self.tap=UITapGestureRecognizer()
        setup()
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        self.NameTextField.text = "\(user.name)"
        self.EmailTextField.text = "\(userEmail)"
        self.fbProfilePictureView.profileID = user.objectID
        /* make the API call */
        //        FBRequestConnection.startForMyFriendsWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
        //            if error == nil {
        //                var friendObjects = result["data"] as [NSDictionary]
        //                for friendObject in friendObjects {
        //                    println(friendObject["id"] as NSString)
        //                }
        //                println("\(friendObjects.count)")
        //            } else {
        //                println("Error requesting friends list form facebook")
        //                println("\(error)")
        //            }
        //        })
        // Get List Of Friends
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as NSDictionary
            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as NSArray
            
            for i in 0..<data.count {
                let valueDict : NSDictionary = data[i] as NSDictionary
                let name = valueDict.objectForKey("name") as String
                println("the name value is \(name)")
                self.friendList.append(name)
            }
            
            var friends = resultdict.objectForKey("data") as NSArray
            println("Found \(friends.count) friends")
        }
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    @IBAction func SignUp(sender: UIButton) {
        
        if(self.NameTextField.text=="" || self.PasswordTextField.text=="" || self.EmailTextField.text=="")
        {
            self.showNullAlert()
            return
        }
        
        if(delegate != nil){
            var user = PFUser()
            var username = NameTextField.text
            var password = PasswordTextField.text
            var email = EmailTextField.text
            user.username = username
            user.password = password
            user.email = email
            // other fields can be set just like with PFObject
           // user["phone"] = "415-392-0202"
            var error: NSError?
            var succeeded = user.signUp(&error)
            if(!succeeded){
          //      var error: NSError = errorPtr.memory!
                self.showAlert("Alert", Message: "Error: \(error!.debugDescription)")
                return
            }
            delegate!.myVCDidFinish(self, Name: username, Password: password, FriendList: friendList)
        }

    }
    var delegate: SignUpControllerDelegate? = nil
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func showNullAlert(){
        var alert = UIAlertController(title: "Required Field Is Left Blank", message: "Please enter the required field first, and then press the Sign Up button", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlert(Title: NSString, Message: NSString){
        var alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup()
    {
        self.signUpView.addGestureRecognizer(self.tap)
        self.tap.addTarget(self, action: "tapped:")
        let path = UIBezierPath()
        path.moveToPoint(view.center)
        
        let initialPoint = self.fbProfilePictureView.center
        var controlPoint1 = CGPoint(x: initialPoint.x + 30.0,
            y: initialPoint.y - 100.0)
        var controlPoint2 = CGPoint(x: controlPoint1.x + 30.0,
            y: controlPoint1.y - 100.0)
        var destination = CGPoint(x: initialPoint.x + 90,
            y: initialPoint.y)
        
        path.addCurveToPoint(destination, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        controlPoint1.x += 90.0
        controlPoint2.x += 90.0
        destination.x += 90.0
        
        path.addCurveToPoint(destination, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.CGPath
        animation.duration = 1.5
        self.fbProfilePictureView.layer.addAnimation(animation, forKey: "bezier")
        
        self.fbProfilePictureView.center = destination
    }
    
    func tapped(sender: UIGestureRecognizer)
    {
        self.view.endEditing(true)
    }


}
