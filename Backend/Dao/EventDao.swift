//
//  EventDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/25.
//

import Foundation
import PerfectMySQL

protocol EventDao{
    func insertEvent(vo: NewEvent) -> ReturnGenericity<String>
    
    func updateEvent(vo: UpdateEvent) -> ReturnGenericity<String>
    
    func updateClause(vo: UpdateClause) -> ReturnGenericity<String>
    
    func deleteEvent(vo: EventID) -> ReturnGenericity<String>
    
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String>
    
    func listCreateEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func listJoinEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func listAllEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func listEvents(vo: EventConditions) -> ReturnGenericity<[EventInfo]>
}

class EventGroupDaoImpl : EventDao{
    let connector: Connector = Connector()
    
    /// create group event
    ///
    /// - Parameter vo: new group event info
    /// - Returns: success/fail
    func insertEvent(vo: NewEvent) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `event_group` (`group_id`, `publisher_id`, `event_name`, `time`, `location`)
            VALUES ('\(vo.groupID!)', '\(vo.publisherID)','\(vo.eventName)', '\(vo.time)', '\(vo.location)')
            """)
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "event exist", info: mysql!.errorMessage())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `event_id` FROM `event_group` WHERE `group_id`='\(vo.groupID!)' AND `event_name` = '\(vo.eventName)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var eventID: String = ""
        res.forEachRow { row in
            eventID = row.first!!
        }
        
        let createInGroupEventQuery = mysql!.query(statement: """
            CREATE TABLE `event_group_\(eventID)` (
            `clause_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
            `clause_name` varchar(256) NOT NULL DEFAULT '',
            `start_time` datetime NOT NULL,
            `end_time` datetime NOT NULL,
            `auth_level` int(1) NOT NULL,
            `introduction` varchar(256) NOT NULL DEFAULT '',
            `limit` int(4) NOT NULL,
            `total` int(4) DEFAULT '0',
            `members` varchar(1024) DEFAULT '',
            PRIMARY KEY (`clause_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            """)
        guard createInGroupEventQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        var initQuery: Bool = true
        for clause in vo.clauses {
            initQuery = mysql!.query(statement: """
                INSERT INTO `event_group_\(eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLevel.getValue())', '\(clause.introduction)', '\(clause.limit)');
                """)
            if !initQuery{
                break
            }
        }
        
        guard initQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// modify group event info
    ///
    /// - Parameter vo: group event info
    /// - Returns: success/fail
    func updateEvent(vo: UpdateEvent) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `event_group`
            SET `event_name` = '\(vo.eventName)', `time` = '\(vo.time)', `location` = '\(vo.location)'
            WHERE `event_id` = '\(vo.eventID)'
            """)
        guard changeQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// modify group clause info
    ///
    /// - Parameter vo: group clause info
    /// - Returns: success/fail
    func updateClause(vo: UpdateClause) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `event_group_\(vo.eventID)`
            SET `clause_name` = '\(vo.clauseName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)', `introduction` = '\(vo.introduction)'
            WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard changeQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete group event
    ///
    /// - Parameter vo: group event ID
    /// - Returns: success/fail
    func deleteEvent(vo: EventID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `event_group` WHERE `event_id` = '\(vo.eventID)'
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let deleteTableQuery = mysql!.query(statement: """
            DROP TABLE `event_group_\(vo.eventID)`
            """)
        guard deleteTableQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete group clause
    ///
    /// - Parameter vo: group clause ID
    /// - Returns: success/fail
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `events_group_\(vo.eventID)` WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// get group event create by user
    ///
    /// - Parameter vo: user id
    /// - Returns: events
    func listCreateEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[EventInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_group` WHERE `publisher_id` = \(vo.userID)
            """)
        guard getQuery else{
            return ReturnGenericity<[EventInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var event: EventInfo = EventInfo(groupID: "")
        var events: [EventInfo] = []
        res.forEachRow(callback: {row in
            event.eventID = row[0]!
            event.groupID = row[1]!
            event.publisherID = vo.userID
            event.eventName = row[3]!
            event.time = row[4]!
            event.location = row[5]!
            events.append(event)
        })
        
        return ReturnGenericity<[EventInfo]>(state: true, message: "", info: events)
    }
    
    /// get group event user joint in
    ///
    /// - Parameter vo: user id
    /// - Returns: events
    func listJoinEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[EventInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_group` WHERE `event_id` IN (
                SELECT `event_id` FROM `order_group` WHERE `user_id` = '\(vo.userID)')
            """)
        guard getQuery else{
            return ReturnGenericity<[EventInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var event: EventInfo = EventInfo(groupID: "")
        var events: [EventInfo] = []
        res.forEachRow(callback: {row in
            event.eventID = row[0]!
            event.groupID = row[1]!
            event.publisherID = row[2]!
            event.eventName = row[3]!
            event.time = row[4]!
            event.location = row[5]!
            events.append(event)
        })
        
        return ReturnGenericity<[EventInfo]>(state: true, message: "", info: events)
    }
    
    /// get group event not begin
    ///
    /// - Parameter vo: user id
    /// - Returns: events
    func listAllEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[EventInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_group` WHERE `time`>'\(TimeTool.getCurrentDay())' `group_id` IN (
                SELECT `group_id` FROM `invitation_accept` WHERE `user_id` = '\(vo.userID)')
            """)
        guard getQuery else{
            return ReturnGenericity<[EventInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var event: EventInfo = EventInfo(groupID: "")
        var events: [EventInfo] = []
        res.forEachRow(callback: {row in
            event.eventID = row[0]!
            event.groupID = row[1]!
            event.publisherID = row[2]!
            event.eventName = row[3]!
            event.time = row[4]!
            event.location = row[5]!
            events.append(event)
        })
        
        return ReturnGenericity<[EventInfo]>(state: true, message: "", info: events)
    }
    
    /// <#Description#>
    ///
    /// - Parameter vo: <#vo description#>
    /// - Returns: <#return value description#>
    func listEvents(vo: EventConditions) -> ReturnGenericity<[EventInfo]> {
        return ReturnGenericity<[EventInfo]>(info: [])
    }
    
}

class EventGlobalDaoImpl: EventDao{
    let connector: Connector = Connector()

    /// create global event
    ///
    /// - Parameter vo: new global event info
    /// - Returns: success/fail
    func insertEvent(vo: NewEvent) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `event_global` (`publisher_id`, `event_name`, `time`, `location`)
                VALUES ('\(vo.publisherID)','\(vo.eventName)', '\(vo.time)', '\(vo.location)')
            """)
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "event exist", info: mysql!.errorMessage())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `event_id` FROM `event_global` WHERE `event_name` = '\(vo.eventName)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var eventID: String = ""
        res.forEachRow { row in
            eventID = row.first!!
        }
        
        let createInGroupEventQuery = mysql!.query(statement: """
            CREATE TABLE `event_global_\(eventID)` (
            `clause_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
            `clause_name` varchar(256) NOT NULL DEFAULT '',
            `start_time` datetime NOT NULL,
            `end_time` datetime NOT NULL,
            `auth_level` int(1) NOT NULL,
            `introduction` varchar(256) NOT NULL DEFAULT '',
            `limit` int(4) NOT NULL,
            `total` int(4) DEFAULT '0',
            `members` varchar(1024) DEFAULT '',
            PRIMARY KEY (`clause_id`)
            ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
            """)
        guard createInGroupEventQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        var initQuery: Bool = true
        for clause in vo.clauses {
            initQuery = mysql!.query(statement: """
                INSERT INTO `event_global_\(eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLevel.getValue())', '\(clause.introduction)', '\(clause.limit)');
                """)
            if !initQuery{
                break
            }
        }
        
        guard initQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// modify global event info
    ///
    /// - Parameter vo: global event info
    /// - Returns: success/fail
    func updateEvent(vo: UpdateEvent) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `event_global`
                SET `event_name` = '\(vo.eventName)', `time` = '\(vo.time)', `location` = '\(vo.location)'
                WHERE `event_id` = '\(vo.eventID)'
            """)
        guard changeQuery else {
            return ReturnGenericity<String>(state: false, message: "event exist", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// modify global clause info
    ///
    /// - Parameter vo: global clause info
    /// - Returns: success/fail
    func updateClause(vo: UpdateClause) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `event_global_\(vo.eventID)`
                SET `clause_name` = '\(vo.clauseName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)', ` introduction` = '\(vo.introduction)'
                WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard changeQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete global event
    ///
    /// - Parameter vo: global event ID
    /// - Returns: success/fail
    func deleteEvent(vo: EventID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `event_global` WHERE `event_id` = '\(vo.eventID)'
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let deleteTableQuery = mysql!.query(statement: """
            DROP TABLE `event_global_\(vo.eventID)`
            """)
        guard deleteTableQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete global clause
    ///
    /// - Parameter vo: global clause ID
    /// - Returns: success/fail
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `event_global_\(vo.eventID)` WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// get global event create by user
    ///
    /// - Parameter vo: user id
    /// - Returns: events
    func listCreateEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[EventInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_global` WHERE `publisher_id` = \(vo.userID)
            """)
        guard getQuery else{
            return ReturnGenericity<[EventInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var event: EventInfo = EventInfo(groupID: "")
        var events: [EventInfo] = []
        res.forEachRow(callback: {row in
            event.eventID = row[0]!
            event.publisherID = vo.userID
            event.eventName = row[2]!
            event.time = row[3]!
            event.location = row[4]!
            events.append(event)
        })
        
        return ReturnGenericity<[EventInfo]>(state: true, message: "", info: events)
    }
    
    /// get events user joint in
    ///
    /// - Parameter vo: user id
    /// - Returns: events
    func listJoinEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[EventInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_global` WHERE `event_id` IN (
            SELECT `event_id` FROM `order_global` WHERE `user_id` = '\(vo.userID)')
            """)
        guard getQuery else{
            return ReturnGenericity<[EventInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var event: EventInfo = EventInfo(groupID: "")
        var events: [EventInfo] = []
        res.forEachRow(callback: {row in
            event.eventID = row[0]!
            event.publisherID = row[1]!
            event.eventName = row[2]!
            event.time = row[3]!
            event.location = row[4]!
            events.append(event)
        })
        
        return ReturnGenericity<[EventInfo]>(state: true, message: "", info: events)
    }
    
    /// get global event not begin
    ///
    /// - Parameter vo: user id (not used)
    /// - Returns: events
    func listAllEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[EventInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_global` WHERE `time`>'\(TimeTool.getCurrentDay())'
            """)
        guard getQuery else{
            return ReturnGenericity<[EventInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var event: EventInfo = EventInfo(groupID: "")
        var events: [EventInfo] = []
        res.forEachRow(callback: {row in
            event.eventID = row[0]!
            event.publisherID = row[1]!
            event.eventName = row[2]!
            event.time = row[3]!
            event.location = row[4]!
            events.append(event)
        })
        
        return ReturnGenericity<[EventInfo]>(state: true, message: "", info: events)
    }
    
    /// <#Description#>
    ///
    /// - Parameter vo: <#vo description#>
    /// - Returns: <#return value description#>
    func listEvents(vo: EventConditions) -> ReturnGenericity<[EventInfo]> {
        return ReturnGenericity<[EventInfo]>(info: [])
    }
}
