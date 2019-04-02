//
//  EventDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/25.
//

import Foundation
import PerfectMySQL

protocol EventDao{
    func createEvent(vo: NewEventInfo) -> ReturnGenericity<String>
    
    func changeEventInfo(vo: EventInfo) -> ReturnGenericity<String>
    
    func changeClauseInfo(vo: ClauseInfo) -> ReturnGenericity<String>
    
    func deleteEvent(vo: EventIDInfo) -> ReturnGenericity<String>
    
    func deleteClause(vo: ClauseIDInfo) -> ReturnGenericity<String>
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any>
}

class EventGroupDaoImpl : EventDao{
    let connector: Connector = Connector()
    
    /// create group event
    ///
    /// - Parameter vo: new group event info
    /// - Returns: success/fail
    func createEvent(vo: NewEventInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `event_group` (`group_id`, `publisher_id`, `event_name`, `start_time`, `end_time`, `introduction`)
            VALUES ('\(vo.groupID!)', '\(vo.userID)','\(vo.eventName)', '\(vo.startTime)', '\(vo.endTime)', '\(vo.introduction)')
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
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLevel)', '\(clause.introduction)', '\(clause.limit)');
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
    func changeEventInfo(vo: EventInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `event_group`
            SET `event_name` = '\(vo.eventName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)', `introduction` = '\(vo.introduction)'
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
    func changeClauseInfo(vo: ClauseInfo) -> ReturnGenericity<String> {
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
    func deleteEvent(vo: EventIDInfo) -> ReturnGenericity<String> {
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
    func deleteClause(vo: ClauseIDInfo) -> ReturnGenericity<String> {
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
    
    /// <#Description#>
    ///
    /// - Parameter vo: <#vo description#>
    /// - Returns: <#return value description#>
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any> {
        return ReturnGenericity<Any>(info: "")
    }
    
}

class EventGlobalDaoImpl: EventDao{
    let connector: Connector = Connector()

    /// create global event
    ///
    /// - Parameter vo: new global event info
    /// - Returns: success/fail
    func createEvent(vo: NewEventInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `event_global` (`publisher_id`, `event_name`, `start_time`, `end_time`, `introduction`)
                VALUES ('\(vo.userID)','\(vo.eventName)', '\(vo.startTime)', '\(vo.endTime)', '\(vo.introduction)')
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
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
            """)
        guard createInGroupEventQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        var initQuery: Bool = true
        for clause in vo.clauses {
            initQuery = mysql!.query(statement: """
                INSERT INTO `event_global_\(eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLevel)', '\(clause.introduction)', '\(clause.limit)');
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
    func changeEventInfo(vo: EventInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `event_global`
                SET `event_name` = '\(vo.eventName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)', `introduction` = '\(vo.introduction)'
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
    func changeClauseInfo(vo: ClauseInfo) -> ReturnGenericity<String> {
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
    func deleteEvent(vo: EventIDInfo) -> ReturnGenericity<String> {
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
    func deleteClause(vo: ClauseIDInfo) -> ReturnGenericity<String> {
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
    
    /// <#Description#>
    ///
    /// - Parameter vo: <#vo description#>
    /// - Returns: <#return value description#>
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any> {
        return ReturnGenericity<Any>(info: "")
    }
}
