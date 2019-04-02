//
//  EventVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

struct newClause {
    var clauseName: String
    var startTime: Date
    var endTime: Date
    var clauseAuthLevel: AuthLevel
    var introduction: String
    var limit: Int
    
    init(clauseName: String, startTime: Date, endTime: Date, clauseAuthLevel: AuthLevel, introduction: String, limit: Int) {
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.clauseAuthLevel = clauseAuthLevel
        self.introduction = introduction
        self.limit = limit
    }
}

struct NewEventInfo{
    var userID: String
    var groupID: String?
    var eventName: String
    var startTime: Date
    var endTime: Date
    var introduction: String
    var clauses: [newClause]
    
    init(userID: String, groupID: String?, eventName: String, startTime: Date, endTime: Date , introduction: String, clauses: [newClause]) {
        self.userID = userID
        self.groupID = groupID
        self.eventName = eventName
        self.startTime = startTime
        self.endTime = endTime
        self.introduction = introduction
        self.clauses = clauses
    }
}

struct EventInfo {
    var eventID: String
    var eventName: String
    var startTime: Date
    var endTime: Date
    var introduction: String
    
    init(eventID: String, eventName: String, startTime: Date, endTime: Date , introduction: String) {
        self.eventID = eventID
        self.eventName = eventName
        self.startTime = startTime
        self.endTime = endTime
        self.introduction = introduction
    }
}

struct ClauseInfo {
    var eventID: String
    var clauseID: String
    var clauseName: String
    var startTime: Date
    var endTime: Date
    var introduction: String
    
    init(eventID:String, clauseID: String, clauseName: String, startTime: Date, endTime: Date,introduction: String) {
        self.eventID = eventID
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.introduction = introduction
    }
}

struct EventIDInfo {
    var eventID: String
    init(eventID: String) {
        self.eventID = eventID
    }
}

struct ClauseIDInfo {
    var eventID: String
    var clauseID: String
    init(eventID:String, clauseID:String) {
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct EventConditions {
    //TODO
}
