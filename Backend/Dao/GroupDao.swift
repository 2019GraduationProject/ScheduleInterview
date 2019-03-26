//
//  GroupDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/23.
//

import Foundation
import PerfectMySQL

class GroupDao{
    let connector:Connector = Connector()

    
    /// add group
    ///
    /// - Parameter vo: new group info
    /// - Returns: success: group id
    func createGroup(vo: NewGroupInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createAndGetQuery = mysql!.query(statement: """
            INSERT INTO `groups` (`creatorID`, `groupName`, `introduction`) VALUES (\(vo.userID), '\(vo.groupName)', '\(vo.introduction)');
            SELECT `groupID` FROM `groups` WHERE `groupName`='\(vo.groupName)';
            """)
        guard createAndGetQuery else {
            return ReturnGenericity<String>(state: false, message: "group exist", info: "")
        }
        
        let res = mysql!.storeResults()!
        var groupID: String = ""
        
        res.forEachRow { row in
            groupID = row.first!!
        }
        
        let createGroupQuery = mysql!.query(statement: """
            CREATE TABLE `group_\(groupID)` (
                `id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
                `memberID` int(8) unsigned zerofill NOT NULL,
                `authLv` int(1) unsigned NOT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `memberID` (`memberID`),
                CONSTRAINT `group_\(groupID)_ibfk_2` FOREIGN KEY (`memberID`) REFERENCES `users` (`userID`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
            """)
        guard createGroupQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: groupID)
    }
}
