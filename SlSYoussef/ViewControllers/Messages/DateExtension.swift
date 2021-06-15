//
//  DateExtension.swift
//  SlSYoussef
//
//  Created by Hady Helal on 08/05/2021.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
extension Date {
    func getMessageTime(for date : Date , dayOfWeek : String) -> String{
        var finalDateFormation : String = ""
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: date)
        print("hahahahahaha\(dateString)")
        switch dayOfWeek {
        case "Saturday":
            finalDateFormation.append("Sat. ")
        case "Sunday":
            finalDateFormation.append("Sun. ")
        case "Monday":
            finalDateFormation.append("Mon. ")
        case "Tuesday":
            finalDateFormation.append("Tue. ")
        case "Wednesday":
            finalDateFormation.append("Wed. ")
        case "Thursday":
            finalDateFormation.append("Thu. ")
        case "Friday":
            finalDateFormation.append("Fri. ")
        default:
            break
        }
        
        finalDateFormation.append(dateString)
        return finalDateFormation

    }

    func getPastTime(for date : Date) -> String {

        var secondsAgo = Int(Date().timeIntervalSince(date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) secs ago"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) min ago"
            }else{
                return "\(min) mins ago"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hr ago"
            } else {
                return "\(hr) hrs ago"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                return "\(day) day ago"
            }else{
                return "\(day) days ago"
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, hh:mm a"
            formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: date)
            return strDate
        }
    }
}
