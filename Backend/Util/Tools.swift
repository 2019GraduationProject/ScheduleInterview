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
