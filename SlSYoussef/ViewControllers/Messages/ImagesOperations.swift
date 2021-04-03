//
//  ImagesOperations.swift
//  SlSYoussef
//
//  Created by Hady Helal on 30/03/2021.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
struct ImagesOperations {
    
    static func DownloadImage(url : String , completed : @escaping (_ image : UIImage) ->Void){
        let resource = ImageResource(downloadURL: URL(string: url)!)
        let placeholder = UIImage(named: "face")
        let processor = RoundCornerImageProcessor(cornerRadius: 20.0)
        let img = UIImageView()
        img.kf.indicatorType = .activity
        img.kf.setImage(with: resource, placeholder: placeholder, options: [.processor(processor)]) { (receivedSize, totalSize) in
            let precentage = (Float(receivedSize) / Float(totalSize)) + 100
            print("Downloading progress \(precentage)%")
            
        } completionHandler: { [self] (result) in
            if self.handle(result) {
                completed(img.image!)
            }
        }
    }
    
    static func handle (_ result : Result<RetrieveImageResult,KingfisherError>) -> Bool{
        var status : Bool
        switch result {
        case .success(let retrievedImage):
            status = true
            let image = retrievedImage.image
            let casheType = retrievedImage.cacheType
            let source = retrievedImage.source
            let originalResource = retrievedImage.originalSource
            _ = """
            ImageSize:
            \(image.size)
            
            cashe:
            \(casheType)
            
            source:
            \(source)

            Original source:
            \(originalResource)
             
            """
           // self.showAlert(title: "Success!", message: message)
            return true
        case .failure(let error):
            status = false
           // self.showAlert(title: "Error", message: error.localizedDescription)
        }
        return status
    }
    
    static func trans(data : [String : Any]) -> Date? {
        guard let stamp = data["time"] as? Timestamp else {
            return nil
        }
        return stamp.dateValue()
    }
}