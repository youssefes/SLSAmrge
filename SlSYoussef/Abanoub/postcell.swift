//
//  postcell.swift
//  EventOrganizer
//
//  Created by Bob Oror on 1/20/21.
//  Copyright © 2021 Bob. All rights reserved.
//

import UIKit

class postcell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var profilrimg: UIImageView!
    @IBOutlet weak var postimg: UIImageView!
    
    @IBOutlet weak var timeago: UILabel!
    
    @IBOutlet weak var Description: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
