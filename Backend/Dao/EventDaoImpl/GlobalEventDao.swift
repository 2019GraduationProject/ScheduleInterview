//
//  GlobalEventDao.swift
//  Backend
//
//  Created by TygaG on 2019/4/12.
//

import Foundation
import PerfectMySQL

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
        
        let createGlobalEventQuery = mysql!.query(statement: """
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
        guard createGlobalEventQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        var initQuery: Bool = true
        for clause in vo.clauses {
            initQuery = mysql!.query(statement: """
                INSERT INTO `event_global_\(eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.globalAuthLevel!.getValue())', '\(clause.introduction)', '\(clause.limit)');
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
            SET `clause_name` = '\(vo.clauseName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)',`auth_level`='\(vo.globalAuthLevel!.getValue())', `introduction` = '\(vo.introduction)', `limit`='\(vo.limit)'
            WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard changeQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// add clause
    ///
    /// - Parameter vo: clause info
    /// - Returns: success/fail
    func insertClause(vo: NewClause) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `event_global_\(vo.eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
            VALUES ('\(vo.clauseName)', '\(vo.startTime)', '\(vo.endTime)', '\(vo.globalAuthLevel!.getValue())', '\(vo.introduction)', '\(vo.limit)');
            """)
        guard insertQuery else {
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
            DELETE `event_global`, `order_global` FROM `event_global`
            LEFT JOIN `order_global` ON `event_global`.`event_id`=`order_global`.`event_id`
            WHERE `event_global`.`event_id` = '\(vo.eventID)'
            """)
        
        let dropQuery = mysql!.query(statement: """
            DROP TABLE `event_global_\(vo.eventID)`
            """)
        guard deleteQuery && dropQuery else {
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
            DELETE `event_global_\(vo.eventID)`,`order_global` FROM `event_global_\(vo.eventID)`
            LEFT JOIN `order_global` ON `event_global_\(vo.eventID)`.`clause_id`=`order_global`.`clause_id`
            WHERE `event_global_\(vo.eventID)`.`clause_id` = '\(vo.clauseID)'
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
        var event: EventInfo = EventInfo(groupID: nil)
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
        var event: EventInfo = EventInfo(groupID: nil)
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
        var event: EventInfo = EventInfo(groupID: nil)
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
    
    /// get global clauses
    ///
    /// - Parameter vo: event id
    /// - Returns: clauses
    func listClause(vo: EventID) -> ReturnGenericity<[ClauseInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[ClauseInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_global_\(vo.eventID)`
            """)
        guard getQuery else{
            return ReturnGenericity<[ClauseInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var clause: ClauseInfo = ClauseInfo()
        var clauses: [ClauseInfo] = []
        res.forEachRow(callback: {row in
            clause.clauseID = row[0]!
            clause.clauseName = row[1]!
            clause.startTime = row[2]!
            clause.endTime = row[3]!
            clause.globalAuthLevel = GlobalAuthLevel(rawValue: Int(row[4]!)!)
            clause.limit = Int(row[5]!)!
            clause.total = Int(row[6]!)!
            clauses.append(clause)
        })
        
        return ReturnGenericity<[ClauseInfo]>(state: true, message: "", info: clauses)
    
    }
    
    /// <#Description#>
    ///
    /// - Parameter vo: <#vo description#>
    /// - Returns: <#return value description#>
    func listEvents(vo: EventConditions) -> ReturnGenericity<[EventInfo]> {
        return ReturnGenericity<[EventInfo]>(info: [])
    }
}
