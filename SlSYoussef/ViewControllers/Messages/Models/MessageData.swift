//
//  messageData.swift
//  SlSYoussef
//
//  Created by Hady Helal on 30/03/2021.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

struct MessageData {
    let messageTime : Date
    let messageBody : String
    let senderImage : UIImage
    let senderName  : String
    let senderUID   : String
    let channelID   : String
    let seen        : Bool
    let isOnline    : Bool
}
