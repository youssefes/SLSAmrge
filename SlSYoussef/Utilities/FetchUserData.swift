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
    
    let root = Database.database()
    static func fetchFBUserData(complation : @escaping ((_ user : UserDataModel?)-> Void)){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                var userData =  UserDataModel()
                
                userData.displayName = user.displayName
                userData.email = user.email
                userData.photoURL = user.photoURL
                userData.uid = user.uid
                print("=========================")
                print("=========================")
                
                print(user.uid)
                
                print("=========================")
                print("=========================")
                complation(userData)
            }
            else {
                complation(nil)
                print("Failsssss")
            }
        }
       
    }
    
}

extension Database {
//    static func fetchUserWithUid(Uid : String, complation : @escaping (SampleDataOfUser)-> Void){
//        let collectionOfFireStor = Firestore.firestore().collection("Users").document(Uid)
//
//        collectionOfFireStor.getDocument { (user, error) in
//            if error == nil{
//                guard  let user =  user?.data() else {
//                    return
//                }
//                    let data = SampleDataOfUser(userId: Uid, dictionary: user)
//                print(data)
//                complation(data)
//            }else{
//                print("error in fatch data")
//            }
//
//        }
//
//    }
}
