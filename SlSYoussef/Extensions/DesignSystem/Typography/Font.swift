//
//  Font.swift
//  Opportunities
//
//  Created by youssef on 12/1/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation


enum Font : String {
    case Bold = "Montserrat-Bold.ttf"
    case semaiBold = "Montserrat-SemiBold"
    case Light =  "Montserrat-Light"
    case Medium = "Montserrat-Medium"
    var name : String {
        return self.rawValue
    }
}
