//
//  InitializationViewController.swift
//  Help
//
//  Created by demo on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import CoreLocation
import UIKit

class InitializationViewController: UIViewController, CLLocationManagerDelegate, SignUpControllerDelegate{
    @IBOutlet var name: UITextField!
    @IBOutlet var initializationView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    var tap: UITapGestureRecognizer!
    var myObject : PFObject!
    var myID : String!
    var friendList: [String] = []
    //var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.passwordTextField.secureTextEntry = true
        self.tap=UITapGestureRecognizer()
        setup()
    }
    

    func myVCDidFinish(controller:SignUpViewController,Name:String,Password:String, FriendList:[String]){
        name.text = Name
        passwordTextField.text = Password
        self.friendList = FriendList
        controller.navigationController?.popViewControllerAnimated(true)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
                   //Stuff to do before you segue
        
            var text:String = segue.identifier as String!
            switch text {
            case "toIMController":
                if var nextViewController = segue.destinationViewController as? MessageTableViewController {
                    var nameString = self.name.text
                    var passwordString = self.passwordTextField.text
                    
                    if(nameString=="" || passwordString=="")
                    {
                        self.showNullAlert()
                        return
                    }
                    
                    var user: PFUser!
                    var error: NSError?
                    user = PFUser.logInWithUsername(nameString, password: passwordString, error: &error)
                    if (user != nil) {
                        // Do stuff after successful login.
                        self.myObject = PFObject(className: "PeopleLocation")
                        self.myObject["Name"]=user.username
                        self.myObject.save()
                        nextViewController.friendList = self.friendList
                        nextViewController.myID = self.myID
                    } else {
                        // The login failed. Check error to see why.
                        println("Error: \(error!.localizedDescription)")
                        self.showAlert("Alert", Message: "Error: \(error.debugDescription)")
                        return
                        
                    }
                                        }
            
            case "toSignUp":if var nextViewController = segue.destinationViewController as? SignUpViewController {
                 nextViewController.delegate = self
                }
            default:
                break
        }

        
        
    }
    
    func showNullAlert(){
    var alert = UIAlertController(title: "Name or Password Field Is Left Blank", message: "Please enter name and password first, and then press Sign In", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showUserNotExistAlert(){
        var alert = UIAlertController(title: "User not exist", message: "User does not exist, please try again", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func showAlert(Title: NSString, Message: NSString){
        var alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func setup()
    {
        self.initializationView.addGestureRecognizer(self.tap)
        self.tap.addTarget(self, action: "tapped:")
    }
    
    func tapped(sender: UIGestureRecognizer)
    {
    self.view.endEditing(true)
    }
    

}
