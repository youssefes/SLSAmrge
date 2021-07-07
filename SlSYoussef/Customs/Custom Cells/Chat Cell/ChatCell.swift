//
//  chatCell.swift
//  SLS
//
//  Created by Hady on 1/25/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var senderImage: UIImageView!
    
    @IBOutlet weak var messageTime: UILabel!
    
    @IBOutlet weak var senderName: UILabel!
    
    @IBOutlet weak var messageBody: UILabel!
    
    @IBOutlet weak var onlineStateImage: UIImageView!
    
    var array : [Int] = []
    var arrays = [Int]()
    var arrayFour = [Int](repeating: 5, count: 2)
    var multiDimentsion = [[Int]] ()
    static let cellIdentifier = "Chat cell ID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            senderName.textColor  = .label
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            messageBody.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            messageBody.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        

        /* cell.senderImage.layer.cornerRadius = cell.senderImage.frame.width / 2
         cell.senderImage.clipsToBounds = true */
         //or we can use
         
          senderImage.layer.cornerRadius = 30.0
          senderImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
