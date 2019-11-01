//
//  SocialLoginClass.swift
//  Demo_MVVM
//
//  Created by Tushar on 01/11/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

private var shared:SocialLoginClass? = nil

class SocialLoginClass: NSObject {

    let loginManager = LoginManager()
//    let objLoginModel = LoginViewModel()
    
    class func sharedManager() -> SocialLoginClass{
        if shared == nil{
            shared = SocialLoginClass()
        }
        return shared!
    }
}

extension SocialLoginClass{
    
    // Facebook SignIn
    
    func loginWithFacebook(completion:@escaping (Bool, String) -> Void){
        
        loginManager.logIn(permissions: ["email"], from: APPDELEGATE.window?.rootViewController) { (result, error) in
            if (error == nil)
            {
                let fbloginresult : LoginManagerLoginResult = result! //fbloginresult.isCancelled
                if(fbloginresult.grantedPermissions.contains("email")){
                    // start loader
                    self.getFBUserData(completion: { (status, error) in
                        completion(status,error)
                    })
                }
                else{
                    // Stop Loader
                    completion(false,(error?.localizedDescription)!)
                }
            }
        }
    }
    
    // Get Facebook LoggedIn User data.
    
    func getFBUserData(completion:@escaping (Bool, String) -> Void){
        
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result!)
                    self.loginManager.logOut()
                    if let dataDic = result as? [String:Any]{
                        LoginViewModel.sharedLogin().Email = "\(dataDic["email"]!)"
                        completion(true,"")
                    }else{
                        completion(false,"Data parsing fail!")
                    }
                }else{
                    completion(false,(error?.localizedDescription)!)
                }
            })
        }
    }
    
    // Google SignIn
    
    func loginWithGoogle() {
        
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENTID
        GIDSignIn.sharedInstance()?.shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = APPDELEGATE.window?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension SocialLoginClass : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error == nil{
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
            let email = user.profile.email
            LoginViewModel.sharedLogin().Email = email!
            LoginViewModel.sharedLogin().getLoginData { (response) in
                print("response : \(response)")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disConnect googlePlus Login" + error.localizedDescription)
    }
    
    func signIn(_ signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        APPDELEGATE.window?.rootViewController!.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(_ signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        APPDELEGATE.window?.rootViewController!.dismiss(animated: true, completion: nil)
    }
}
