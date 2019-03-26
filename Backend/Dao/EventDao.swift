//
//  EventDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/25.
//

import Foundation
import PerfectMySQL

class EventDao{
    let connector: Connector = Connector()
    
    
    /// create group event
    ///
    /// - Parameter vo: new group event info
    /// - Returns: success/fail
    func createInGroupEvent(vo: NewInGroupEventInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `event_group` (`group_id`, `publisher_id`, `event_name`, `start_time`, `end_time`, `introduction`)
                VALUES ('\(vo.groupID)', '\(vo.userID)','\(vo.eventName)', '\(vo.startTime)', '\(vo.endTime)', '\(vo.introduction)');
            SELECT `event_id` FROM `event_group` WHERE `group_id`='\(vo.groupID)' AND `event_name` = '\(vo.eventName)';
            """)
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "event exist", info: "")
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
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        var initInsertQuery = ""
        for clause in vo.clauses {
            initInsertQuery += """
            INSERT INTO `event_group_\(eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLevel)', '\(clause.introduction)', '\(clause.limit)');
            """
        }
        
        let initQuery = mysql!.query(statement: initInsertQuery)
        guard initQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// create global event
    ///
    /// - Parameter vo: new global event info
    /// - Returns: success/fail
    func createGlobalEvent(vo: NewGlobalEventInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `event_global` (`publisher_id`, `event_name`, `start_time`, `end_time`, `introduction`)
                VALUES ('\(vo.userID)','\(vo.eventName)', '\(vo.startTime)', '\(vo.endTime)', '\(vo.introduction)');
            SELECT `event_id` FROM `event_global` WHERE `event_name` = '\(vo.eventName)';
            """)
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "event exist", info: "")
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
        
        var initInsertQuery = ""
        for clause in vo.clauses {
            initInsertQuery += """
            INSERT INTO `event_global_\(eventID)` (`clause_name`, `start_time`, `end_time`, `auth_level`, `introduction`, `limit`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLevel)', '\(clause.introduction)', '\(clause.limit)');
            """
        }
        
        let initQuery = mysql!.query(statement: initInsertQuery)
        guard initQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// modify group event info
    ///
    /// - Parameter vo: group event info
    /// - Returns: success/fail
    func changeInGroupEventInfo(vo: InGroupEventInfo) -> ReturnGenericity<String> {
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
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// modify global event info
    ///
    /// - Parameter vo: global event info
    /// - Returns: success/fail
    func changeGlobalEventInfo(vo: GlobalEventInfo) -> ReturnGenericity<String> {
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
            return ReturnGenericity<String>(state: false, message: "event exist", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// modify group clause info
    ///
    /// - Parameter vo: group clause info
    /// - Returns: success/fail
    func changeInGroupClausetInfo(vo: InGroupClauseInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `events_group_\(vo.eventID)`
                SET `clause_Name` = '\(vo.clauseName)', `start_time` = '\(vo.startTime)', `end_time` = '\(vo.endTime)', ` introduction` = '\(vo.introduction)'
                WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard changeQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// modify global clause info
    ///
    /// - Parameter vo: global clause info
    /// - Returns: success/fail
    func changeGlobalClauseInfo(vo: GlobalClauseInfo) -> ReturnGenericity<String> {
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
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete group event
    ///
    /// - Parameter vo: group event ID
    /// - Returns: success/fail
    func deleteInGroupEvent(vo: InGroupEventIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `event_group` WHERE `event_id` = '\(vo.eventID)';
            DROP TABLE `event_group_\(vo.eventID)`;
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// delete global event
    ///
    /// - Parameter vo: global event ID
    /// - Returns: success/fail
    func deleteGlobalEvent(vo: GlobalEventIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `event_global` WHERE `event_id` = '\(vo.eventID)';
            DROP TABLE `event_global_\(vo.eventID)`;
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    /// delete group clause
    ///
    /// - Parameter vo: group clause ID
    /// - Returns: success/fail
    func deleteInGroupClause(vo: InGroupClauseIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `events_group_\(vo.eventID)` WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// delete global clause
    ///
    /// - Parameter vo: global clause ID
    /// - Returns: success/fail
    func deleteGlobalClause(vo: GlobalClauseIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `event_global_\(vo.eventID)` WHERE `clause_id` = '\(vo.clauseID)'
            """)
        guard deleteQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
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
