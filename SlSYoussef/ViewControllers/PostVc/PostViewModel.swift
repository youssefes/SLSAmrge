//
//  PostViewModel.swift
//  SlSYoussef
//
//  Created by youssef on 2/15/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import Firebase

class PostViewModel{
    
    
    var userUid : String = ""
    func ViewDidLoadbind(){
        
    }
    
    func uplaoadImage(image : UIImage, complactionhandle : @escaping(_ success:Bool,_ ImageUrl : String?) -> Void){
        //Create a reference to the image
        let imageName    = UUID().uuidString
        let imageRef = Storage.storage().reference().child("images").child("\(imageName).jpg")
        
        // Get image data
        if let uploadData = image.pngData() {
            
            // Upload image to Firebase Cloud Storage
            imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard error == nil else {
                    complactionhandle(false, nil)
                    print(error?.localizedDescription)
                    return
                }
                // Get full image url
                imageRef.downloadURL {(url, error) in
                    guard let downloadURL = url else {
                         print(error?.localizedDescription)
                        complactionhandle(false, nil)
                        return
                    }
                    // Save url to database
                    complactionhandle(true, downloadURL.absoluteString)
                }
            }
        }
        
    }
    
}

