//
//  File.swift
//  SlSYoussef
//
//  Created by youssef on 2/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserRepositoryManger {
    
    
    static func createUser(withEmail: String, WithUsername : String, data : Data, copmlatiomHandler  :@escaping(_ error : String?,_ Seccess :Bool) -> Void){
        let dp  = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: withEmail, password: WithUsername) { (result, error) in
            if error == nil {
                if let result = result {
                    dp.collection("User").document("\(result.user.uid)").setData(["uid" : result.user.uid,"userName" : withEmail , "email" : withEmail]){ (er) in
                        guard er != nil else {
                            copmlatiomHandler(er?.localizedDescription,false)
                            return
                        }
                        UserRepositoryManger.uploadImage(userUid: result.user.uid, Image: data) { (error, secsess) in
                            if secsess{
                                copmlatiomHandler(nil,secsess)
                            }else{
                                copmlatiomHandler(error ,false)
                            }
                        }
                    }
                }else { print("error with result \(String(describing: result))") }
            }else {
                copmlatiomHandler(error?.localizedDescription, false)
            }
        }
    }
    
    
static func uploadImage(userUid : String, Image : Data, copmlatiomHandler  :@escaping(_ error : String?,_ Seccess :Bool) -> Void){
        let imageName    = UUID().uuidString
        let imgReference = Storage.storage().reference().child("UsersRefs").child("\(imageName).jpg")
        
        imgReference.putData(Image, metadata: nil) { (metaData, error) in
            if let err = error {
                copmlatiomHandler(err.localizedDescription,false)
            }else{
                imgReference.downloadURL { (url, error) in
                    if let error = error {
                        copmlatiomHandler(error.localizedDescription,false)
                    }
                    
                    guard let url = url else {
                        copmlatiomHandler("error in url",false)
                        return
                    }
                    
                    let urlString = url.absoluteString
                    let dataref = Firestore.firestore().collection("user").document(userUid)
                    
                    let data = ["profilPic" :  urlString]
                    
                    dataref.setData(data, merge: true) { (error) in
                        if let error = error {
                            copmlatiomHandler(error.localizedDescription,false)
                        }else{
                            copmlatiomHandler(nil,true)
                        }
                    }
                }
            }
        }
    }
    
}
