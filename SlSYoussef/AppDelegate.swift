//
//  AppDelegate.swift
//  SLS
//
//  Created by Hady on 1/24/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//


import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application( application,  didFinishLaunchingWithOptions: launchOptions )
        
        
        
        print("USER IN SCEEEEEENEE DELEGATE")
        if UtilityFunctions.isLoggedIn == true {
            DispatchQueue.main.async {
//                print("USER IS SIGNING IN AND HEADING TO NEW FEEDS")
//                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = HomeViewController()
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
        }
        IQKeyboardManager.shared.enable = true
        //MARK: - Firebase Google Authintaication
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        print("This is the client ID \(FirebaseApp.app()?.options.clientID ?? "NO id here.......")")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // if the user is signed in go to New feeds
        
        //check if the user now is logged in breviously
        if GIDSignIn.sharedInstance()?.currentUser != nil{
            UtilityFunctions.isLoggedIn = true
        }else if let token = AccessToken.current, !token.isExpired {
            print("USER LOGGED IN WITH FACEBOOK AND ACCESS TOKEN IS TRUEE")
            UtilityFunctions.isLoggedIn = true
            // User is logged in, do work such as go to next view controller.
        }else if Auth.auth().currentUser != nil {
           print("LOGED IN WITH E-MAIL")
            UtilityFunctions.isLoggedIn = true
        }else{
            print("Is signed in with apple")
        }
        
        //MARK: - Firebase Facebook Authentication
        
        return true
    }
    
    //  Facebook Firebase Authentication
    func application(  _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    
    // Google firebase auth with credential
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in wit GOOGLE before or they have since signed out.")
                
               
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            if let error = error {
                print("firebasee sin in error")
                print(error)
                return
            }
            
            print("User is signed in with firebase with Email: \(user.profile.email ?? "")")
            UtilityFunctions.isLoggedIn = true
        }
    }
    
    
}
