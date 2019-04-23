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
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
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
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
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
        
        //add creator
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `group_\(groupID)` (`user_id`, `auth_level`) VALUES (\(vo.creatorID), '\(GroupAuthLevel.CREATOR.getValue())')
            """)
        guard createGroupQuery && insertQuery else {
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "wrong", info: mysql!.errorMessage())
        }
        
        guard transaction.commit() else {
            return ReturnGenericity<String>(state: false, message: "commit transaction failed", info: "")
        }
        guard transaction.endTransaction() else {
            return ReturnGenericity<String>(state: false, message: "ends transaction failed", info: "")
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
            member.authLevel = GroupAuthLevel(rawValue: Int(row[2]!)!)!
            members.append(member)
        })
        
        return ReturnGenericity<[MemberInfo]>(state: true, message: "", info: members)
    }
    
    
    /// get group info by group id
    ///
    /// - Parameter vo: group id
    /// - Returns: success:group info/fail
    func getGroupInfo(vo: GroupID) -> ReturnGenericity<GroupInfo> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<GroupInfo>(state: false, message: "connect database failed", info: GroupInfo())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `group` WHERE `group_id`='\(vo.groupID)'
            """)
        guard getQuery else {
            return ReturnGenericity<GroupInfo>(state: false, message: "database wrong", info: GroupInfo())
        }
        
        let res = mysql!.storeResults()
        
        var group: GroupInfo = GroupInfo()
        res?.forEachRow(callback: { row in
            group.groupID = row[0]!
            group.creatorID = row[1]!
            group.groupName = row[2]!
        })
        
        return ReturnGenericity<GroupInfo>(state: true, message: "", info: group)
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
        
        let updateQuery = mysql!.query(statement: """
            UPDATE `group` SET `group_name`='\(vo.groupName)' WHERE `group_id`='\(vo.groupID)'
            """)
        guard updateQuery else{
            return ReturnGenericity<String>(state: false, message: "group name exist", info: mysql!.errorMessage())
        }
    
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
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `event_id` FROM `event_group` WHERE `group_id` = '\(vo.groupID)'
            """)
        guard getQuery else{
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()
        
        var dropString: String = ""
        res!.forEachRow(callback: { row in
            dropString += ", `event_group_\(row.first!!)`"
        })
        
        let deleteQuery = mysql!.query(statement: """
            DELETE `group`,`invitation`,`invitation_accept`,`invitation_refuse`,`event_group`,`order_group` FROM `group`
            LEFT JOIN `invitation` ON `group`.`group_id` = `invitation`.`group_id`
            LEFT JOIN `invitation_accept` ON `group`.`group_id` = `invitation_accept`.`group_id`
            LEFT JOIN `invitation_refuse` ON `group`.`group_id` = `invitation_refuse`.`group_id`
            LEFT JOIN `event_group` ON `group`.`group_id` = `event_group`.`group_id`
            LEFT JOIN `order_group` ON `group`.`group_id` = `order_group`.`group_id`
            WHERE `group`.`group_id` = '\(vo.groupID)';
            """)
        let dropQuery = mysql!.query(statement: """
            DROP TABLE `group_\(vo.groupID)` \(dropString)
            """)
        guard deleteQuery&&dropQuery else{
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        guard transaction.commit() else {
            return ReturnGenericity<String>(state: false, message: "commit transaction failed", info: "")
        }
        guard transaction.endTransaction() else {
            return ReturnGenericity<String>(state: false, message: "ends transaction failed", info: "")
        }
        
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
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `event_id` FROM `event_group` WHERE `publisher_id` = '\(vo.userID)'
            """)
        guard getQuery else{
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()
        //成员发布的组内事件
        var events: [String] = []
        res!.forEachRow(callback: { row in
            events.append(row.first!!)
        })
        let eventDao: EventDao = EventGroupDaoImpl()
        
        let deleteQuery = mysql!.query(statement: """
            DELETE `group_\(vo.groupID)`, `invitation_accept`, `order_group` FROM `group_\(vo.groupID)`
            LEFT JOIN `invitation_accept` ON `group_\(vo.groupID)`.`user_id`=`invitation_accept`.`user_id`
            LEFT JOIN `order_group` ON `group_\(vo.groupID)`.`user_id`=`order_group`.`user_id`
            WHERE `group_\(vo.groupID)`.`user_id` = '\(vo.userID)';
            """)
        var dropQuery = true
        for eventID in events {
            dropQuery = dropQuery && eventDao.deleteEvent(vo: EventID(eventID: eventID), mysql: mysql).state
            if !dropQuery{
                break
            }
        }
        guard deleteQuery&&dropQuery else{
            guard transaction.rollback() else {
                return ReturnGenericity<String>(state: false, message: "rollback transaction failed", info: "")
            }
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        guard transaction.commit() else {
            return ReturnGenericity<String>(state: false, message: "commit transaction failed", info: "")
        }
        guard transaction.endTransaction() else {
            return ReturnGenericity<String>(state: false, message: "ends transaction failed", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
}
