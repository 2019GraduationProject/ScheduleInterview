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
            INSERT INTO `group_events` (`groupID`, `publisherID`, `eventName`, `start`, `end`, `brief`)
                VALUES ('\(vo.groupID)', '\(vo.userID)','\(vo.eventName)', '\(vo.start)', '\(vo.end)', '\(vo.brief)');
            SELECT `eventID` FROM `group_events` WHERE `groupID`='\(vo.groupID)' AND `eventName` = '\(vo.eventName)';
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
            CREATE TABLE `g_event_\(eventID)` (
                `clauseID` int(8) unsigned NOT NULL AUTO_INCREMENT,
                `clauseName` varchar(256) NOT NULL DEFAULT '',
                `startTime` datetime NOT NULL,
                `endTime` datetime NOT NULL,
                `authLv` int(1) NOT NULL,
                `brief` varchar(256) NOT NULL DEFAULT '',
                `numOfMember` int(4) NOT NULL,
                `total` int(4) DEFAULT '0',
                `members` varchar(1024) DEFAULT '',

                PRIMARY KEY (`clauseID`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            """)
        guard createInGroupEventQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        var initInsertQuery = ""
        for clause in vo.clauses {
            initInsertQuery += """
            INSERT INTO `g_event_\(eventID)` (`clauseName`, `startTime`, `endTime`, `authLv`, `brief`, `numOfMember`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLv)', '\(clause.brief)', '\(clause.numOfMember)');
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
            INSERT INTO `events` (`publisherID`, `eventName`, `start`, `end`, `brief`)
                VALUES ('\(vo.userID)','\(vo.eventName)', '\(vo.start)', '\(vo.end)', '\(vo.brief)');
            SELECT `eventID` FROM `events` WHERE `eventName` = '\(vo.eventName)';
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
            CREATE TABLE `event_\(eventID)` (
                `clauseID` int(8) unsigned NOT NULL AUTO_INCREMENT,
                `clauseName` varchar(256) NOT NULL DEFAULT '',
                `startTime` datetime NOT NULL,
                `endTime` datetime NOT NULL,
                `authLv` int(1) NOT NULL,
                `brief` varchar(256) NOT NULL DEFAULT '',
                `numOfMember` int(4) NOT NULL,
                `total` int(4) DEFAULT '0',
                `members` varchar(1024) DEFAULT '',
            PRIMARY KEY (`clauseID`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            """)
        guard createInGroupEventQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        var initInsertQuery = ""
        for clause in vo.clauses {
            initInsertQuery += """
            INSERT INTO `event_\(eventID)` (`clauseName`, `startTime`, `endTime`, `authLv`, `brief`, `numOfMember`)
                VALUES ('\(clause.clauseName)', '\(clause.startTime)', '\(clause.endTime)', '\(clause.clauseAuthLv)', '\(clause.brief)', '\(clause.numOfMember)');
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
            UPDATE `group_events`
                SET `eventName` = '\(vo.eventName)', `start` = '\(vo.start)', `end` = '\(vo.end)', `brief` = '\(vo.brief)'
                WHERE `eventID` = '\(vo.eventID)'
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
            UPDATE `events`
            SET `eventName` = '\(vo.eventName)', `start` = '\(vo.start)', `end` = '\(vo.end)', `brief` = '\(vo.brief)'
            WHERE `eventID` = '\(vo.eventID)'
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
            UPDATE `g_events_\(vo.eventID)`
            SET `clauseName` = '\(vo.clauseName)', `startTime` = '\(vo.startTime)', `endTime` = '\(vo.endTime)', ` brief` = '\(vo.brief)'
            WHERE `clauseID` = '\(vo.clauseID)'
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
            UPDATE `g_events_\(vo.eventID)`
            SET `clauseName` = '\(vo.clauseName)', `startTime` = '\(vo.startTime)', `endTime` = '\(vo.endTime)', ` brief` = '\(vo.brief)'
            WHERE `clauseID` = '\(vo.clauseID)'
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
            DELETE FROM `group_events` WHERE `eventID` = '\(vo.eventID)';
            DROP TABLE `g_event_\(vo.eventID)`;
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
            DELETE FROM `events` WHERE `eventID` = '\(vo.eventID)';
            DROP TABLE `event_\(vo.eventID)`;
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
            DELETE FROM `g_events_\(vo.eventID)` WHERE `clauseID` = '\(vo.clauseID)'
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
            DELETE FROM `events_\(vo.eventID)` WHERE `clauseID` = '\(vo.clauseID)'
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
