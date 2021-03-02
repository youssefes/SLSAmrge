//
//  ChatVc Picker+Ext.swift
//  SlSYoussef
//
//  Created by Hady on 2/24/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

extension ChatVC : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            insertMessage([chosenimage])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func handleUploadImage(){
        let imagepicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagepicker.sourceType = .camera
        } else {
            imagepicker.sourceType = .photoLibrary
        }
        
        imagepicker.allowsEditing = true
        imagepicker.delegate      = self
        present(imagepicker, animated: true, completion: nil)
    }
    

}
