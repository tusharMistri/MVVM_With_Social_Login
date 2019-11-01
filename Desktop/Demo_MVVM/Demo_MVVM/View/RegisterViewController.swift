//
//  RegisterViewController.swift
//  Demo_MVVM
//
//  Created by Tushar on 31/10/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var objLoginModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
