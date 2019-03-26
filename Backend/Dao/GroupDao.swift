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
            INSERT INTO `group` (`creator_id`, `group_name`, `introduction`) VALUES (\(vo.userID), '\(vo.groupName)', '\(vo.introduction)');
            SELECT `group_id` FROM `group` WHERE `group_name`='\(vo.groupName)';
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
                `member_id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT,
                `user_id` int(8) unsigned zerofill NOT NULL,
                `auth_level` int(1) unsigned NOT NULL,
                PRIMARY KEY (`member_id`),
                UNIQUE KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8
            """)
        guard createGroupQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: groupID)
    }
}
