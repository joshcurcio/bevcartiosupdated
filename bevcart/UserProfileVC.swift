//
//  UserProfileVC.swift
//  bevcart
//
//  Created by csc313 on 5/7/16.
//  Copyright © 2016 CurcioDoverStudio. All rights reserved.
//

import UIKit
import Firebase
import Stripe

class UserProfileVC: UIViewController {

    @IBOutlet weak var fnameTF: UITextField!
    @IBOutlet weak var lnameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var fname = ""
    var lname = ""
    var phoneNum = ""
    var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(Core.fireBaseRef.authData.uid).observeEventType(.Value, withBlock: { snapshot in
            let datum = snapshot.value as! NSDictionary
            self.fname = datum["fname"] as! String
            self.lname = datum["lname"] as! String
            self.email = datum["email"] as! String
            self.phoneNum = datum["phone_number"] as! String
            
        })
        
        self.fnameTF.text! = self.fname
        self.lnameTF.text! = self.lname
        self.phoneNumTF.text! = self.phoneNum
        self.emailTF.text! = self.email
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonClicked(sender: AnyObject) {
        var profileInfo = ["fname": fnameTF.text!, "lname": lnameTF.text!, "phone_number": phoneNumTF.text!, "email": emailTF.text!]
        Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(Core.fireBaseRef.authData.uid).updateChildValues(profileInfo)
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
