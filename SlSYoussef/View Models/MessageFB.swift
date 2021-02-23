//
//  MessagesFields.swift
//  SlSYoussef
//
//  Created by Hady on 2/23/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

struct MessageFB : Codable {
    var recipientID : String
    var reciverImage : String
    var senderID : String
    var senderImage : String
    var senderName : String
    var text : String
    var time : Date
    var type : String
    
    init?(data : [String : Any]) {
        guard let recipientID = data["recipientID"] as? String,
            let reciverImage = data["reciverImage"] as? String,
            let senderId = data["senderID"] as? String ,
            let senderImage = data["senderImage"] as? String,
            let senderName = data["senderName"] as? String,
            let text = data["text"] as? String,
            let time = data["time"] as? Date,
            let type = data["type"] as? String else {
                return nil
        }
        
        self.recipientID = recipientID
        self.reciverImage = reciverImage
        self.senderID = senderId
        self.senderImage = senderImage
        self.senderName = senderName
        self.text = text
        self.time = time
        self.type = type
    }
}
