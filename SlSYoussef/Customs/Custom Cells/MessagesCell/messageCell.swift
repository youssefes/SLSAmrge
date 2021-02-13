//
//  messageCell.swift
//  SLS
//
//  Created by Hady on 1/26/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {

    static let messageCellID = "messageCellID"
    
    @IBOutlet weak var personPicture: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabel.layer.cornerRadius   = 10
        messageLabel.layer.masksToBounds  = true

        personPicture.layer.cornerRadius  = 15
        personPicture.layer.masksToBounds = true
        
    }
}
