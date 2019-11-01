//
//  AppDelegate.swift
//  Demo_MVVM
//
//  Created by Tushar on 28/10/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn

let GOOGLE_CLIENTID = "296171066110-ost7vo3635cn2gpv0aguvkg8ir60bjbu.apps.googleusercontent.com"

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyBoard = UIStoryboard()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }

    // Call Methdod While seprate after login and without Login User.
    
    func setRootController(){
        storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyBoard.instantiateViewController(withIdentifier: "contentController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }

}

