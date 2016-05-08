//
//  GolfCoursePickerVC.swift
//  
//
//  Created by csc313 on 4/30/16.
//
//

import UIKit
import Firebase
import Stripe

class GolfCoursePickerVC: UIViewController , UIPickerViewDelegate, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var golfCoursePicker: UIPickerView!
    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var holeNumTF: UITextField!
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    
    var golfCourses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Core.orderPrice = 0
        self.golfCoursePicker.delegate = self
        
        let ref = Core.fireBaseRef.childByAppendingPath("courses")
        ref.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let dictionary = snapshot.value as! NSDictionary
            for key in dictionary
            {
                let newCourse = Course()
                
                let datum = key.value as! NSDictionary
                print(datum)
                newCourse.course_name = datum["course_name"] as! String
                let menu = datum["menu"] as! NSDictionary
                newCourse.drinkList = menu["drinks"] as! NSDictionary
                newCourse.foodList = menu["food"] as! NSDictionary
                newCourse.key = key.key as! String
                
                self.golfCourses.append(newCourse)
                self.golfCoursePicker.reloadAllComponents()
                Core.selectedGolfCourse = self.golfCourses[0]
            }
        }
        priceLabel.text? = "$\(Core.orderPrice/100)"

    }
    
    func updatePriceLabel(newPrice: Int)
    {
        priceLabel.text? = "$\(newPrice/100)"
    }
   

    @IBAction func save(sender: AnyObject) {
        if let card = paymentTextField.card {
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let error = error  {
                    
                }
                else if let token1 = token {
                    self.createBackendChargeWithToken(token1) { status in
                        
                    }
                }
            }
        }
    }
    
    func createBackendChargeWithToken(token: STPToken, completion: PKPaymentAuthorizationStatus -> ()) {
        let url = NSURL(string: "http://localhost:3000/checkout")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=\(token.tokenId)&amount=\(Core.orderPrice)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
                var allItems = ["burger" : "0", "beer" : "0", "chips" : "0", "completed" : "false", "hole" : "0", "gatorade" : "0", "water" : "0", "hot_dog" : "0", "user" : "\(Core.fireBaseRef.authData.uid)", "provider" : "n/a", "course" : "\(Core.providerCourse)", "price" : "\(Core.orderPrice)"]

                
                for i in 0...Core.foodList.count-1
                {
                    allItems.updateValue("\(Core.foodList[i].itemQuant)", forKey: Core.foodList[i].itemName)
                }
                for i in 0...Core.drinkList.count-1
                {
                   allItems.updateValue("\(Core.drinkList[i].itemQuant)", forKey: Core.drinkList[i].itemName)
                }
                allItems.updateValue("\(Core.fireBaseRef.authData.uid)", forKey: "user")
                allItems.updateValue("n/a", forKey: "provider")
                allItems.updateValue("\(Core.selectedGolfCourse.course_name)",forKey: "course")
                allItems.updateValue("\(Core.orderPrice)", forKey: "price")
                allItems.updateValue("\(Core.orderQuant)", forKey: "quantity")
                allItems.updateValue("\(self.holeNumTF.text!)", forKey: "hole")
                Core.fireBaseRef.childByAppendingPath("orders").childByAutoId().setValue(allItems)

            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return golfCourses.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return golfCourses[row].course_name + " - " + golfCourses[row].key
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Core.selectedGolfCourse = golfCourses[row]
    }

    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
