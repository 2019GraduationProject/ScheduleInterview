//
//  Tools.swift
//  Backend
//
//  Created by TygaG on 2019/3/23.
//

import Foundation

enum AuthLevel: Int {
    case CREATOR = 5
    case MANAGER = 4
    case VIPMEMBER = 2
    case MEMBER = 1
    
    func getValue() -> Int {
        return self.rawValue
    }
}

enum KindOfEvent: String {
    case GROUP = "group"
    case GLOBAL = "global"
    
    func getValue() -> String {
        return self.rawValue
    }
}

enum Compare: Int {
    case ASCEND = 1
    case SAME = 0
    case DESCEND = -1
}

class TimeTool{
    static func getCurrentTime() -> String {
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

        return dateformatter.string(from: Date())
    }
    
    static func getCurrentDay() -> String {
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        return dateformatter.string(from: Date())
    }
    
    static func compareNow(dateString: String) ->  Compare{
        let date: Date = Date(fromISO8601: dateString)!
        let res = date.compare(Date())
        switch res {
        case .orderedDescending:
            return Compare.ASCEND
        case .orderedSame:
            return Compare.SAME
        case .orderedAscending:
            return Compare.DESCEND
        }
    }
}
