//
//  UtilityFunctions.swift
//  SLS
//
//  Created by Hady on 2/3/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import Photos
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

struct UtilityFunctions {
    
    public static var isLoggedIn = false
    
    //MARK: - to Retreve UIImage from PHAsset
    static  func handlePHImageManager(asset : PHAsset) -> UIImage?{
        var returnedImage : UIImage?
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, _) in
            if let image = image {
                returnedImage = image
            }
            else { returnedImage = nil}
        }
        return returnedImage
    }
    //============================================================//
    
    //MARK: - to Animate Price button
    static func configureLabelAnimation(textField : UITextField , label : UILabel,stack : UIStackView , view : UIView){
        if textField.isEnabled {
            textField.isEnabled   = false
            textField.borderStyle = .none
            textField.text        = .none
            textField.layer.borderColor  = .none // for core graphics
            textField.resignFirstResponder()
            label.removeFromSuperview()
            view.layoutIfNeeded()
            
        } else {
            label.text            = "$"
            stack.addArrangedSubview(label)
            textField.isEnabled   = true
            textField.borderStyle = .roundedRect
            textField.layer.borderColor  = UIColor.systemPink.cgColor // for core graphics
            textField.becomeFirstResponder()
            view.layoutIfNeeded()
        }
    }
    
    //MARK: - Validate SignUp password
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //MARK: - Sign out Operation logic
    static func signOut(_ viewController : UIViewController){
        viewController.showLoadingView()
         if Auth.auth().currentUser != nil {
             if GIDSignIn.sharedInstance()?.currentUser != nil{
                 GIDSignIn.sharedInstance()?.signOut()
             }else if let token = AccessToken.current, !token.isExpired {
                 print("USER LOGGED IN WITH FACEBOOK AND ACCESS TOKEN IS TRUEE")
                 LoginManager().logOut()
                 // User is logged in, do work such as go to next view controller.
             }
             
             do {
                viewController.hideLoadingView()
                 try Auth.auth().signOut()
                 UtilityFunctions.isLoggedIn = false
                 print("BACK TO FIRST VIEW ==================")
                 let sb = UIStoryboard(name: "Main", bundle: nil)
                 let vc = sb.instantiateViewController(withIdentifier: "FirstView")
                 viewController.view.window?.rootViewController = vc
                 viewController.view.window?.makeKeyAndVisible()
             } catch let err {
                viewController.showAlert(title: " Sign out Faild", message: err.localizedDescription)
             }
             
         } else {
            viewController.hideLoadingView()
            viewController.showAlert(title: "not Signed in", message: "You trying to sign out while you are not signed in")
             
             print("Try")
         }
         
    }

}
