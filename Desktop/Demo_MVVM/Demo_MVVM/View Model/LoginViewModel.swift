//
//  LoginViewModel.swift
//  Demo_MVVM
//
//  Created by Tushar on 28/10/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

private var shared : LoginViewModel? = nil

class LoginViewModel: NSObject {

    var objUser : UserDetails?
    var Email : String = ""
    let loginManager = LoginManager()
    
    class func sharedLogin() -> LoginViewModel{
        if shared == nil{
            shared = LoginViewModel()
        }
        return shared!
    }
    
    func getLoginData(completion:@escaping (UserDetails) -> Void) {
        
        if (self.Email.isEmptyString()){
            ValidataionClass.sharedInstance().alertMessage(withTitle: APP_TITLE, alertMessage: emailBlank)
        }
        else{
            WebserviceClass.sharedInstance().getApiResponse(type: UserDetails.self, api: WebserviceClass.APIName.getAllUsersData) { (success, response) in
                print(success)
                print(response as Any)
                if success{
                    completion(response!)
                    // Navigate to Home screen, After Login success!
                }
            }
        }
    }
    
    // Facebook SignIn
    
    func loginWithFacebook(completion:@escaping (UserDetails) -> Void){

        SocialLoginClass.sharedManager().loginWithFacebook { (status,error) in
            if status{
                self.getLoginData(completion: { (response) in
                    completion(response)
                })
            }else{
                ValidataionClass.sharedInstance().alertMessage(withTitle: APP_TITLE, alertMessage: error)
            }
        }
    }
    
    func loginWithGoogle(){
        SocialLoginClass.sharedManager().loginWithGoogle()
    }
}
