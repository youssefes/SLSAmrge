//
//  adminTableViewCell.swift
//  SlSYoussef
//
//  Created by youssef on 2/14/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class adminTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOFmember: UIImageView!
    
    @IBOutlet weak var nameOfMember: UILabel!
    
    @IBOutlet weak var createTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func acceptedBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func regictedBtn(_ sender: Any) {
        
    }
    
}
