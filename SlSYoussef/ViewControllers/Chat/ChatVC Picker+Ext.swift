//
//  ChatVc Picker+Ext.swift
//  SlSYoussef
//
//  Created by Hady on 2/24/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
extension ChatVC : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           // print("Now we are Uploading the image...")
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
    
    //MARK: - DOWNLOADING IMAGE FUNCTIONS
    func handle (_ result : Result<RetrieveImageResult,KingfisherError>) -> Bool{
        var status : Bool
        switch result {
        case .success(_):
            status = true
            return true
        case .failure(_):
            status = false
            self.showAlert(title: "Error", message: "Error downloading image please check your internet connection and try again")
        }
        return status
    }
    
    func DownloadImage(url : String , completed : @escaping (_ image : UIImage?) ->Void){
        guard let imgURl = URL(string: url) else {
            self.showAlert(title: "Error", message: "Error downloading images, please check your internet connetion and try again.")
            return
        }
        let resource = ImageResource(downloadURL: imgURl)
        let placeholder = UIImage(named: "face")
        let processor = RoundCornerImageProcessor(cornerRadius: 20.0)
        let img = UIImageView()
        img.kf.indicatorType = .activity
        img.kf.setImage(with: resource, placeholder: placeholder, options: [.processor(processor)]) { (receivedSize, totalSize) in
            let precentage = (Float(receivedSize) / Float(totalSize)) + 100
            
        } completionHandler: { [self] (result) in
            if self.handle(result) {
                completed(img.image!)
            }
        }
    }

}
