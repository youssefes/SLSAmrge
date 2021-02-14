//
//  OrderCell.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    static let cellNibName = "OrderCell"
    static let orderCellId = "OrderCellID"
    @IBOutlet weak var orderStatusBtn: UIButton!
      
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
