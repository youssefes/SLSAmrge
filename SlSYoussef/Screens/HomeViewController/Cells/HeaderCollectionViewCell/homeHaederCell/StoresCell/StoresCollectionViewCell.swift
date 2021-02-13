//
//  StoresCollectionViewCell.swift
//  weNotes
//
//  Created by youssef on 2/8/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class StoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerProfilData: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var StoryImage: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var numberOfFollwers: UILabel!
    
    @IBOutlet weak var likeLib: UILabel!
    @IBOutlet weak var activeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SetUI()
    }
    
    func SetUI(){
        containerProfilData.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
}
