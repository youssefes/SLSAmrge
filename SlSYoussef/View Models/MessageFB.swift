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
    var text : String?
    var time : Date
    var type : String
    var imgUrl : String?
    var seen : Bool
    
    init(text : String ,recipientID : String ,senderID : String, senderImage: String , reciverImage : String ,senderName : String ,time : Date , seen : Bool) {
        self.text         = text
        self.seen         = seen
        self.recipientID  = recipientID
        self.senderID     = senderID
        self.reciverImage = reciverImage
        self.senderImage  = senderImage
        self.senderName   = senderName
        self.time         = time
        self.type         = "text"
    }
    
    init(imgURL : String,recipientID : String ,senderID : String, senderImage: String , reciverImage : String ,senderName : String ,time : Date , seen : Bool) {
        self.seen         = seen
        self.imgUrl       = imgURL
        self.recipientID  = recipientID
        self.reciverImage = reciverImage
        self.senderImage  = senderImage
        self.senderID     = senderID
        self.senderName   = senderName
        self.time         = time
        self.type         = "image"
    }
}
