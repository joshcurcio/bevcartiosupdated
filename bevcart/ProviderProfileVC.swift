//
//  ProviderProfileVC.swift
//  bevcart
//
//  Created by csc313 on 5/7/16.
//  Copyright © 2016 CurcioDoverStudio. All rights reserved.
//

import UIKit
import Firebase
import Stripe

class ProviderProfileVC: UIViewController {

    @IBOutlet weak var fnameTF: UITextField!
    @IBOutlet weak var lnameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var accountNumTF: UITextField!
    @IBOutlet weak var routingNumTF: UITextField!
    
    @IBOutlet weak var walletAmount: UILabel!
    
    var fname = ""
    var lname = ""
    var phoneNum = ""
    var email = ""
    var accountNum = ""
    var routingNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletAmount.text! = "$\(Core.providerCut)"
        
        Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(Core.fireBaseRef.authData.uid).observeEventType(.Value, withBlock: { snapshot in
            let datum = snapshot.value as! NSDictionary
            self.fname = datum["fname"] as! String
            self.lname = datum["lname"] as! String
            self.email = datum["email"] as! String
            self.phoneNum = datum["phone_number"] as! String
            self.accountNum = datum["account_number"] as! String
            self.routingNum = datum["routing_number"] as! String
            
            
        })

        self.fnameTF.text! = self.fname
        self.lnameTF.text! = self.lname
        self.phoneNumTF.text! = self.phoneNum
        self.emailTF.text! = self.email
        self.accountNumTF.text! = self.accountNum
        self.routingNumTF.text! = self.routingNum
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func saveButtonClicked(sender: AnyObject) {
        
        var profileInfo = ["fname": fnameTF.text!, "lname": lnameTF.text!, "phone_number": phoneNumTF.text!, "email": emailTF.text!, "routing_number": routingNumTF.text!, "account_number": accountNumTF.text!]
        Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(Core.fireBaseRef.authData.uid).updateChildValues(profileInfo)
    }
    @IBAction func emptyWalletButtonClicked(sender: AnyObject){
        var newAccount = STPBankAccount()
        newAccount.accountNumber = accountNumTF.text!
        newAccount.routingNumber = routingNumTF.text!
        newAccount.country = "US"
        newAccount.accountHolderType = STPBankAccountHolderType.Company
        newAccount.accountHolderName = "\(fnameTF.text!) \(lnameTF.text!)"
        
       // var bankAccountToken = Stripe.createTokenWithBankAccount(newAccount)
        
      
        //addBackendRecipient(bankAccountToken) { status in
        
        
        
    }
    func addBackendRecipient(token: STPToken, completion: PKPaymentAuthorizationStatus -> ()) {
        let url = NSURL(string: "http://localhost:3000/addRecipient")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=\(token.tokenId)&name=\(token.bankAccount?.accountHolderName)&type=\(token.bankAccount?.accountHolderType)&email=\(emailTF.text!)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
                
            }
        }
        task.resume()
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
