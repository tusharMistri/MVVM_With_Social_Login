//
//  ValidataionClass.swift
//  Demo_MVVM
//
//  Created by Tushar on 28/10/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit

private var shared : ValidataionClass? = nil

class ValidataionClass: NSObject {
    
    class func sharedInstance() -> ValidataionClass {
        if shared == nil{
            shared = ValidataionClass()
        }
        return shared!
    }
    
    func alertMessage(withTitle alertTitle:String, alertMessage:String) {
        let alertController = UIAlertController.init(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(alertAction)
        APPDELEGATE.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension String{
    
    func isEmptyString() -> Bool {
        if self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return true
        }else{
            return false
        }
    }
    
    func isValidEmailAddress() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool{
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    
    func isValidPassword(withLength: String, length validate :Bool) -> Bool{
        if validate{
            if self.isEmptyString() || self.count != withLength.count{
                return false
            }else {
                return true
            }
        }
        else{
            return self.isEmptyString()
        }
    }

}


/*
 
 /***************************************************************/
        Explaination of isValidPhoneNumber function.
 /***************************************************************/
 
 ^     #Match the beginning of the string
 [6-9] #Match a 6, 7, 8 or 9
 \\d   #Match a digit (0-9 and anything else that is a "digit" in the regex engine)
 {9}   #Repeat the previous "\d" 9 times (9 digits)
 $     #Match the end of the string
 
 /***************************************************************/
 
 */
