//
//  Core.swift
//  bevcart
//
//  Created by csc313 on 4/16/16.
//  Copyright © 2016 BevCart. All rights reserved.
//

import UIKit
import Firebase

class Core: NSObject
{
    static var storyboard : UIStoryboard!
    
    static var fireBaseRef = Firebase(url: "https://bevcart.firebaseio.com/")
    
    static func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    static var providerCut = 0.00
    static var provideCutPercentage = 0.8
    
    static var selectedGolfCourse: Course!
    static var orderPrice: Int!
    static var providerCourse: String!
    static var orderQuant: Int!
    
    static var foodList = [FoodItem]()
    static var drinkList = [DrinkItem]()
    
}
