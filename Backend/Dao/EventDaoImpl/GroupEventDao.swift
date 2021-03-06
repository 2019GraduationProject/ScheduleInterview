//
//  GroupEventDao.swift
//  Backend
//
//  Created by TygaG on 2019/4/12.
//

import Foundation
import PerfectMySQL

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
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
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
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var eventID: String = ""
        res.forEachRow { row in
            eventID = row.first!!
        }
        
        let createGroupEventQuery = mysql!.query(statement: """
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
        
        var initQuery: Bool = true
        for clause in vo.clauses {
            initQuery = initQuery && insertClause(vo: clause, mysql: mysql).state
            if !initQuery{
                break
            }
        }
        
        guard createGroupEventQuery && initQuery else {
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        guard transaction.commit() else {
            return ReturnGenericity<String>(state: false, message: "commit transaction failed", info: "")
        }
        guard transaction.endTransaction() else {
            return ReturnGenericity<String>(state: false, message: "ends transaction failed", info: "")
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
            SET `clause_name` = '\(vo.clauseName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)', `auth_level`='\(vo.groupAuthLevel!.getValue())', `introduction` = '\(vo.introduction)', `limit`='\(vo.limit)'
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
    func insertClause(vo: NewClause, mysql: MySQL? = nil) -> ReturnGenericity<String> {
        var mysql: MySQL? = mysql
        if mysql == nil {
            mysql = connector.connected()
            if mysql == nil{
                return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
            }
        }
        
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `event_group_\(vo.eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
            VALUES ('\(vo.clauseName)', '\(vo.startTime)', '\(vo.endTime)', '\(vo.groupAuthLevel!.getValue())', '\(vo.introduction)', '\(vo.limit)');
            """)
        guard insertQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete group event
    ///
    /// - Parameter vo: group event ID
    /// - Returns: success/fail
    func deleteEvent(vo: EventID, mysql: MySQL? = nil) -> ReturnGenericity<String> {
        var mysql: MySQL? = mysql
        if mysql == nil {
            mysql = connector.connected()
            if mysql == nil{
                return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
            }
        }
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE `event_group`, `order_group` FROM `event_group`
            LEFT JOIN `order_group` ON `event_group`.`event_id`=`order_group`.`event_id`
            WHERE `event_group`.`event_id` = '\(vo.eventID)'
            """)
        
        let dropQuery = mysql!.query(statement: """
            DROP TABLE `event_group_\(vo.eventID)`
            """)
        guard deleteQuery && dropQuery else {
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        guard transaction.commit() else {
            return ReturnGenericity<String>(state: false, message: "commit transaction failed", info: "")
        }
        guard transaction.endTransaction() else {
            return ReturnGenericity<String>(state: false, message: "ends transaction failed", info: "")
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
            DELETE `event_group_\(vo.eventID)`,`order_group` FROM `event_group_\(vo.eventID)`
            LEFT JOIN `order_group` ON `event_group_\(vo.eventID)`.`clause_id`=`order_group`.`clause_id`
            WHERE `event_group_\(vo.eventID)`.`clause_id` = '\(vo.clauseID)'
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
            SELECT * FROM `event_group` WHERE `time`>'\(TimeTool.getCurrentDay())' AND `group_id` IN (
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
    
    
    /// get group clauses
    ///
    /// - Parameter vo: event id
    /// - Returns: clauses
    func listClause(vo: EventID) -> ReturnGenericity<[ClauseInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[ClauseInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `event_group_\(vo.eventID)`
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
            clause.groupAuthLevel = GroupAuthLevel(rawValue: Int(row[4]!)!)
            clause.introduction = row[5]!
            clause.limit = Int(row[6]!)!
            clause.total = Int(row[7]!)!
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
