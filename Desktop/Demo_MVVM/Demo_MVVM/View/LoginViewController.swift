//
//  LoginViewController.swift
//  Demo_MVVM
//
//  Created by Tushar on 28/10/19.
//  Copyright © 2019 tushar. All rights reserved.
// https://medium.com/swift2go/a-better-approach-to-text-field-validations-on-ios-81bd87598070

import UIKit

class LoginViewController: UIViewController {
    
    var objLoginModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loginCheck(){
        
        objLoginModel.Email = "abc@gmail.com"
        objLoginModel.getLoginData { (response) in
            print("Response :\(response)")
            self.objLoginModel.objUser = response
        }
    }
    
    @IBAction func FacebookLogin(_ sender: UIButton) {
        objLoginModel.loginWithFacebook { (response) in
            print("Response :\(response)")
        }
    }
    
    @IBAction func GoogleLogin(_ sender: UIButton) {
        objLoginModel.loginWithGoogle()
    }
}
