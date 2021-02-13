//
//  ImagesViewCell.swift
//  SLS
//
//  Created by Hady on 2/3/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class ImagesViewCell: UICollectionViewCell {

    @IBOutlet weak var viewAlphe: UIView!
    @IBOutlet weak var numberOfImage: UILabel!
    @IBOutlet var photeView: UIImageView!
    
    @IBOutlet weak var idk: UILabel!
    static let cellIdentifier = "ImagesViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        photeView.cornerRadius = 10
        viewAlphe.cornerRadius = 10
        photeView.clipsToBounds = true
    }

}
