//
//  EditProfileVM.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class EditProfileVM {
    func configureImageView(userImage : UIImageView){
           userImage.layer.cornerRadius = 50
           userImage.clipsToBounds = true
       }
    
    //MARK: - VC Gestures on screen
    func tapGestureOnScreen(view : UIView){
        let gesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(gesture)
    }
    
   
    
}
