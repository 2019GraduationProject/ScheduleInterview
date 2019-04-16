//
//  ClauseDTO.swift
//  Backend
//
//  Created by TygaG on 2019/4/12.
//

import Foundation

//DB
struct Clause {
    var clauseID: String
    var clauseName: String
    var startTime: String
    var endTime: String
    var groupAuthLevel: GroupAuthLevel?
    var globalAuthLevel: GlobalAuthLevel?
    var introduction: String
    var limit: Int
    var total: Int
    
    init(clauseID:String, clauseName: String, startTime: String, endTime: String, groupAuthLevel: GroupAuthLevel?, globalAuthLevel: GlobalAuthLevel?,introduction: String, limit: Int, total: Int) {
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.groupAuthLevel = groupAuthLevel
        self.globalAuthLevel = globalAuthLevel
        self.introduction = introduction
        self.limit = limit
        self.total = total
    }
}

struct NewClause {
    var eventID: String
    var clauseName: String
    var startTime: String
    var endTime: String
    var groupAuthLevel: GroupAuthLevel?
    var globalAuthLevel: GlobalAuthLevel?
    var introduction: String
    var limit: Int
    
    init(eventID:String,clauseName: String, startTime: String, endTime: String, groupAuthLevel: GroupAuthLevel?, globalAuthLevel: GlobalAuthLevel?, introduction: String, limit: Int) {
        self.eventID = eventID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.groupAuthLevel = groupAuthLevel
        self.globalAuthLevel = globalAuthLevel
        self.introduction = introduction
        self.limit = limit
    }
}

struct UpdateClause {
    var eventID: String
    var clauseID: String
    var clauseName: String
    var startTime: String
    var endTime: String
    var groupAuthLevel: GroupAuthLevel?
    var globalAuthLevel: GlobalAuthLevel?
    var introduction: String
    var limit: Int
    
    init(eventID: String,clauseID:String, clauseName: String, startTime: String, endTime: String, groupAuthLevel: GroupAuthLevel?, globalAuthLevel: GlobalAuthLevel?, introduction: String, limit: Int) {
        self.eventID = eventID
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.groupAuthLevel = groupAuthLevel
        self.globalAuthLevel = globalAuthLevel
        self.introduction = introduction
        self.limit = limit
    }
}

struct ClauseInfo {
    var clauseID: String
    var clauseName: String
    var startTime: String
    var endTime: String
    var groupAuthLevel: GroupAuthLevel?
    var globalAuthLevel: GlobalAuthLevel?
    var introduction: String
    /// 人数限制
    var limit: Int
    /// 当前总人数
    var total: Int
    
    init(clauseID:String = "", clauseName: String = "", startTime: String = "", endTime: String = "", groupAuthLevel: GroupAuthLevel? = GroupAuthLevel.MEMBER, globalAuthLevel: GlobalAuthLevel? = GlobalAuthLevel.ALL, introduction: String = "", limit: Int = 0, total: Int = 0) {
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.groupAuthLevel = groupAuthLevel
        self.globalAuthLevel = globalAuthLevel
        self.introduction = introduction
        self.limit = limit
        self.total = total
    }
}

struct ClauseID {
    var eventID: String
    var clauseID: String
    init(eventID:String, clauseID:String) {
        self.eventID = eventID
        self.clauseID = clauseID
    }
}
