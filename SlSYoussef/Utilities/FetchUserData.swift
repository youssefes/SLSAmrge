//
//  FetchUserData.swift
//  SLS
//
//  Created by Hady on 2/7/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

struct FetchUserData {
    
    
    static func fetchFBUserData(complation : @escaping ((_ user : UserDataModel?)-> Void)){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                var userData =  UserDataModel()
                userData.displayName = user.displayName
                userData.email = user.email
                userData.photoURL = user.photoURL
                userData.uid = user.uid
                complation(userData)
            }
            else {
                complation(nil)
                print("Failsssss")
            }
        }
       
    }
    
}
