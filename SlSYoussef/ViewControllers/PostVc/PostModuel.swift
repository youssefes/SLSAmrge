//
//  PostModuel.swift
//  SlSYoussef
//
//  Created by youssef on 2/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

struct PostModel {
    var id : String
    var postContext : Postcontext
    var date : Date
    var userId : String
}

struct Postcontext {
    var image : [String]?
    var text : String?
    
}
