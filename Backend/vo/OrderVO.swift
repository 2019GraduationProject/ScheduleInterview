//
//  OrderVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

struct InGroupOrderInfo {
    var userID: String
    var groupID: String
    var eventID:String
    var clauseID:String
    
    init(userID: String, groupID: String, eventID: String, clauseID:String) {
        self.userID = userID
        self.groupID = groupID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct GlobalOrderInfo {
    var userID: String
    var eventID:String
    var clauseID:String
    
    init(userID: String, eventID: String, clauseID:String) {
        self.userID = userID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct InGroupOrderIDInfo {
    var userID: String
    var groupID: String
    var eventID:String
    var clauseID:String
    var orderID: String
    
    init(userID: String, groupID: String, eventID: String, clauseID:String, orderID:String) {
        self.userID = userID
        self.groupID = groupID
        self.eventID = eventID
        self.clauseID = clauseID
        self.orderID = orderID
    }
}

struct GlobalOrderIDInfo {
    var userID: String
    var eventID:String
    var clauseID:String
    var orderID: String
    
    init(userID: String, eventID: String, clauseID:String, orderID:String) {
        self.userID = userID
        self.eventID = eventID
        self.clauseID = clauseID
        self.orderID = orderID
    }
}
