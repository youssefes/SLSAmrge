//
//  ImageMediaItem.swift
//  SlSYoussef
//
//  Created by Hady on 2/24/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MessageKit

 struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

    init(imageURL: URL) {
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage(imageLiteralResourceName: "ppp")
    }
}
