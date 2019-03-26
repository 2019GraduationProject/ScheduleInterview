//
//  EventVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

// brief: brief introduction
struct newClause {
    var clauseName: String
    var startTime: Date
    var endTime: Date
    var clauseAuthLv: AuthLevel
    var brief: String
    var numOfMember: Int
    
    init(clauseName: String, startTime: Date, endTime: Date, clauseAuthLv: AuthLevel, brief: String, numOfMember: Int) {
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.clauseAuthLv = clauseAuthLv
        self.brief = brief
        self.numOfMember = numOfMember
    }
}

struct NewInGroupEventInfo{
    var userID: String
    var groupID: String
    var eventName: String
    var start: Date
    var end: Date
    var brief: String
    var clauses: [newClause]

    init(userID: String, groupID: String, eventName: String, start: Date, end: Date , brief: String, clauses: [newClause]) {
        self.userID = userID
        self.groupID = groupID
        self.eventName = eventName
        self.start = start
        self.end = end
        self.brief = brief
        self.clauses = clauses
    }
}

struct NewGlobalEventInfo {
    var userID: String
    var eventName: String
    var start: Date
    var end: Date
    var brief: String
    var clauses: [newClause]
    
    init(userID: String, eventName: String, start: Date, end: Date ,brief: String, clauses: [newClause]) {
        self.userID = userID
        self.eventName = eventName
        self.start = start
        self.end = end
        self.brief = brief
        self.clauses = clauses
    }
}

struct InGroupEventInfo {
    var eventID: String
    var eventName: String
    var start: Date
    var end: Date
    var brief: String
    
    init(eventID: String, eventName: String, start: Date, end: Date ,brief: String) {
        self.eventID = eventID
        self.eventName = eventName
        self.start = start
        self.end = end
        self.brief = brief
    }
}

struct InGroupClauseInfo {
    var eventID: String
    var clauseID: String
    var clauseName: String
    var startTime: Date
    var endTime: Date
    var brief: String
    
    init(eventID:String, clauseID: String, clauseName: String, startTime: Date, endTime: Date,brief: String) {
        self.eventID = eventID
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.brief = brief
    }
}

struct GlobalEventInfo {
    var eventID: String
    var eventName: String
    var start: Date
    var end: Date
    var brief: String
    
    init(eventID: String, eventName: String, start: Date, end: Date ,brief: String) {
        self.eventID = eventID
        self.eventName = eventName
        self.start = start
        self.end = end
        self.brief = brief
    }
}

struct GlobalClauseInfo {
    var eventID: String
    var clauseID: String
    var clauseName: String
    var startTime: Date
    var endTime: Date
    var brief: String
    
    init(eventID:String, clauseID: String, clauseName: String, startTime: Date, endTime: Date, brief: String) {
        self.eventID = eventID
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.brief = brief
    }
}

struct InGroupEventIDInfo {
    var eventID: String
    init(eventID: String) {
        self.eventID = eventID
    }
}

struct GlobalEventIDInfo {
    var eventID: String
    init(eventID: String) {
        self.eventID = eventID
    }
}

struct InGroupClauseIDInfo {
    var eventID: String
    var clauseID: String
    init(eventID:String, clauseID:String) {
        self.eventID = eventID
        self.clauseID = clauseID
    }
}

struct GlobalClauseIDInfo {
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
