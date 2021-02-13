//
//  CommentCollectionViewCell.swift
//  SLS
//
//  Created by youssef on 2/10/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imageofCommentoner: UIImageView!
    
    @IBOutlet weak var commentlbl: UILabel!
    @IBOutlet weak var namLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.cornerRadius =  25
    }

}
