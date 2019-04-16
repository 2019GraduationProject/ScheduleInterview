//
//  OrderVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

//DB
struct GroupOrder {
    var orderID:String
    var userID: String
    var groupID: String
    var eventID:String
    var clauseID:String
    
    init(orderID:String, userID: String, groupID: String, eventID: String, clauseID:String) {
        self.orderID = orderID
        self.userID = userID
        self.groupID = groupID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

//DB
struct GlobalOrder {
    var orderID: String
    var userID: String
    var eventID:String
    var clauseID:String
    
    init(orderID:String, userID: String, eventID: String, clauseID:String) {
        self.orderID = orderID
        self.userID = userID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct GroupOrderInfo {
    var orderID:String
    var groupID: String
    var eventID:String
    var clauseID:String
    
    init(orderID:String = "", groupID: String = "", eventID: String = "", clauseID:String = "") {
        self.orderID = orderID
        self.groupID = groupID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct GlobalOrderInfo {
    var orderID: String
    var eventID:String
    var clauseID:String
    
    init(orderID:String = "",eventID: String = "", clauseID:String = "") {
        self.orderID = orderID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct NewGroupOrder {
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

struct NewGlobalOrder {
    var userID: String
    var eventID:String
    var clauseID:String
    
    init(userID: String, eventID: String, clauseID:String) {
        self.userID = userID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct GroupOrderID {
    var orderID:String
    var userID: String
    var groupID: String
    var eventID:String
    var clauseID:String
    
    init(orderID:String, userID: String, groupID: String, eventID: String, clauseID:String) {
        self.orderID = orderID
        self.userID = userID
        self.groupID = groupID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct GlobalOrderID {
    var orderID:String
    var userID: String
    var eventID:String
    var clauseID:String
    
    init(orderID:String, userID: String, eventID: String, clauseID:String) {
        self.orderID = orderID
        self.userID = userID
        self.eventID = eventID
        self.clauseID = clauseID
    }
}
