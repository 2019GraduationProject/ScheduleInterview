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
    var clauseAuthLevel: AuthLevel
    var introduction: String
    var limit: Int
    var total: Int
    var members: String
    
    init(clauseID:String, clauseName: String, startTime: String, endTime: String, clauseAuthLevel: AuthLevel, introduction: String, limit: Int, total: Int, members: String) {
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.clauseAuthLevel = clauseAuthLevel
        self.introduction = introduction
        self.limit = limit
        self.total = total
        self.members = members
    }
}

struct newClause {
    var clauseName: String
    var startTime: String
    var endTime: String
    var clauseAuthLevel: AuthLevel
    var introduction: String
    var limit: Int
    
    init(clauseName: String, startTime: String, endTime: String, clauseAuthLevel: AuthLevel, introduction: String, limit: Int) {
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.clauseAuthLevel = clauseAuthLevel
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
    var clauseAuthLevel: AuthLevel
    var introduction: String
    var limit: Int
    
    init(eventID: String,clauseID:String, clauseName: String, startTime: String, endTime: String, clauseAuthLevel: AuthLevel, introduction: String, limit: Int) {
        self.eventID = eventID
        self.clauseID = clauseID
        self.clauseName = clauseName
        self.startTime = startTime
        self.endTime = endTime
        self.clauseAuthLevel = clauseAuthLevel
        self.introduction = introduction
        self.limit = limit
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
