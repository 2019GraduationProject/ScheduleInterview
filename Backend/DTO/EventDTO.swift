//
//  EventVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

//DB
struct Event{
    var eventID: String
    var groupID: String?
    var publisherID: String
    var eventName: String
    var time: String
    var location: String
    
    init(eventID:String, groupID: String?, publisherID:String, eventName: String, time: String , location: String) {
        self.eventID = eventID
        self.groupID = groupID
        self.publisherID = publisherID
        self.eventName = eventName
        self.time = time
        self.location = location
    }
}

struct NewEvent{
    var publisherID: String
    var groupID: String?
    var eventName: String
    var time: String
    var location: String
    var clauses: [newClause]
    
    init(publisherID: String, groupID: String?, eventName: String, time: String , location: String, clauses: [newClause]) {
        self.publisherID = publisherID
        self.groupID = groupID
        self.eventName = eventName
        self.time = time
        self.location = location
        self.clauses = clauses
    }
}

struct UpdateEvent{
    var eventID: String
    var groupID: String?
    var eventName: String
    var time: String
    var location: String
    
    init(eventID:String, groupID: String?, eventName: String, time: String, location: String) {
        self.eventID = eventID
        self.groupID = groupID
        self.eventName = eventName
        self.time = time
        self.location = location
    }
}

struct EventInfo{
    var eventID: String
    var groupID: String?
    var publisherID: String
    var eventName: String
    var time: String
    var location: String
    
    init(eventID:String = "", groupID: String?, publisherID:String = "", eventName: String = "", time:String = "", location: String = "") {
        self.eventID = eventID
        self.groupID = groupID
        self.publisherID = publisherID
        self.eventName = eventName
        self.time = time
        self.location = location
    }
}

struct EventID {
    var eventID: String
    init(eventID: String) {
        self.eventID = eventID
    }
}

struct EventConditions {
    //TODO
}
