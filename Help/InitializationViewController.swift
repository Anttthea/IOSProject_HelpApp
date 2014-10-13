//
//  InitializationViewController.swift
//  Help
//
//  Created by demo on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class InitializationViewController: UIViewController {
    @IBOutlet var name: UITextField!
    @IBOutlet var initializationView: UIView!

    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tap=UITapGestureRecognizer()
        setup()
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
        if(self.name.text=="")
        {
            self.showNullAlert()
            return
        }
        else
        {
            switch segue.identifier {
            case "toIMController":
                if var firstViewController = segue.destinationViewController as? FirstViewController {
                    firstViewController.myName = self.name.text
                }
            
            default:
                break
        }
        }
        
    }
    
    func showNullAlert(){
    var alert = UIAlertController(title: "Name Field Is Left Blank", message: "Please enter a name first, and then press continue", preferredStyle: UIAlertControllerStyle.Alert)
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
