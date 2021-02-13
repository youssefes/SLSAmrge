//
//  CommentofPostCellCollectionViewCell.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class CommentofPostCellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imagesOfCommentsUsers: [UIImageView]!
    
    @IBOutlet weak var imageOfuser: UIImageView!
    @IBOutlet weak var commenttext: UITextView!
    @IBOutlet weak var namelbl: UILabel!
    
    
    @IBOutlet weak var timeLble: UILabel!
    @IBOutlet weak var numberOfLike: UILabel!
    
    
    @IBOutlet weak var numberOfRepley: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func shareBtn(_ sender: Any) {
    }
    @IBAction func likeBtn(_ sender: Any) {
    }
    
    @IBAction func showMoreReplayBtn(_ sender: Any) {
    }
    
}
