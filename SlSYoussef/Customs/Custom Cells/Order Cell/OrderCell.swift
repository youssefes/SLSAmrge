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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureBecomeSellerButton(btn: orderStatusBtn)

    }

    public func configureBecomeSellerButton(btn : UIButton){
        btn.layer.cornerRadius = 11
        btn.clipsToBounds      = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
