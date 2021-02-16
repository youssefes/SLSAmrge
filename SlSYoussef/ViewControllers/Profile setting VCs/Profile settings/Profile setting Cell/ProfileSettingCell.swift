//
//  ProfileSettingCell.swift
//  SLS
//
//  Created by Hady on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class ProfileSettingCell: UITableViewCell {

    
    @IBOutlet var settingImage: UIImageView!
    @IBOutlet var settingName: UILabel!
    
    static let cellID  = "ProfileSettingCell"
    static let nibName = "ProfileSettingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingImage.layer.cornerRadius = 10
        settingImage.clipsToBounds      = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
