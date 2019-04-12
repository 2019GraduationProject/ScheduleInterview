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
    func insertGroup(vo: NewGroup) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `group` (`creator_id`, `group_name`) VALUES (\(vo.creatorID), '\(vo.groupName)')
            """)
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "group exist", info: mysql!.errorMessage())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `group_id` FROM `group` WHERE `group_name`='\(vo.groupName)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
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
            ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8
            """)
        guard createGroupQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `group_\(groupID)` (`user_id`, `auth_level`) VALUES (\(vo.creatorID), '\(AuthLevel.CREATOR.getValue())')
            """)
        guard insertQuery else {
            return ReturnGenericity<String>(state: false, message: "group exist", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: groupID)
    }
    
    
    /// get group create by user
    ///
    /// - Parameter vo: user id
    /// - Returns: group info list
    func listCreateGroups(vo: UserID) -> ReturnGenericity<[GroupInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[GroupInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `group_id`, `group_name` FROM `group` WHERE `creator_id` = \(vo.userID)
            """)
        guard getQuery else {
            return ReturnGenericity<[GroupInfo]>(state: false, message: "database wrong", info: [])
        }
        
        let res = mysql!.storeResults()
        
        var group: GroupInfo = GroupInfo()
        var groups: [GroupInfo] = []
        res?.forEachRow(callback: { row in
            group.groupID = row[0]!
            group.creatorID = vo.userID
            group.groupName = row[1]!
            groups.append(group)
        })
        
        return ReturnGenericity<[GroupInfo]>(state: true, message: "", info: groups)
    }
    
    /// get group user join in
    ///
    /// - Parameter vo: user id
    /// - Returns: group info list
    func listJoinGroups(vo: UserID) -> ReturnGenericity<[GroupInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[GroupInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `group` WHERE `group_id` IN(
                SELECT `group_id` FROM `invitation_accept` WHERE `user_id` = '\(vo.userID)')
            """)
        guard getQuery else {
            return ReturnGenericity<[GroupInfo]>(state: false, message: "database wrong", info: [])
        }
        
        let res = mysql!.storeResults()
        
        var group: GroupInfo = GroupInfo()
        var groups: [GroupInfo] = []
        res?.forEachRow(callback: { row in
            group.groupID = row[0]!
            group.creatorID = row[1]!
            group.groupName = row[2]!
            groups.append(group)
        })
        
        return ReturnGenericity<[GroupInfo]>(state: true, message: "", info: groups)
    }
    
    
    /// get members
    ///
    /// - Parameter vo: group id
    /// - Returns: members
    func listMembers(vo: GroupID) -> ReturnGenericity<[MemberInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[MemberInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `group_\(vo.groupID)`
            """)
        guard getQuery else {
            return ReturnGenericity<[MemberInfo]>(state: false, message: "database wrong", info: [])
        }
        
        let res = mysql!.storeResults()
        
        var member: MemberInfo = MemberInfo()
        var members: [MemberInfo] = []
        res!.forEachRow(callback: { row in
            member.memberID = row[0]!
            member.userID = row[1]!
            member.authLevel = row[2]!
            members.append(member)
        })
        
        return ReturnGenericity<[MemberInfo]>(state: true, message: "", info: members)
    }
    
    
    /// change group info
    ///
    /// - Parameter vo: group info
    /// - Returns: success/fail
    func updateGroup(vo: UpdateGroup) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        // Group Name cannot be changed!
//        let changeQuery = mysql!.query(statement: """
//            UPDATE `group` SET `group_name`='\(vo.groupName)' WHERE `group_id`='\(vo.groupID)'
//            """)
//        guard changeQuery else{
//            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
//        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    
    /// delete group
    ///
    /// - Parameter vo: group id
    /// - Returns: success/fail
    func deleteGroup(vo: GroupID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `group` WHERE `group_id` = '\(vo.groupID)';
            """)
        guard deleteQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        //TODO : 删除组信息相关
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// delete member
    ///
    /// - Parameter vo: group id, member id
    /// - Returns: success/fail
    func deleteMember(vo: RemoveMember) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `group_\(vo.groupID)` WHERE `member_id` = '\(vo.memberID)';
            """)
        guard deleteQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        //TODO: 删除成员信息相关
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
}
