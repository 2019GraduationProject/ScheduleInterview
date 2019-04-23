//
//  InvitationDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/23.
//

import Foundation
import PerfectMySQL

class InvitationDao{
    let connector:Connector = Connector()
    
    
    /// invite user
    ///
    /// - Parameter vo: invitation info
    /// - Returns: success/fail
    func insertInvitation(vo: NewInvitation) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let createQuery = mysql!.query(statement: """
            INSERT INTO `invitation` (`group_id`, `inviter_id`, `invitee_id`) VALUES ('\(vo.groupID)', '\(vo.inviterID)', '\(vo.inviteeID)')
            """)
        
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
        
    }
    
    
    /// accept invitation, delete invitation and add menber
    ///
    /// - Parameter vo: invitation info
    /// - Returns: success/fail
    func insertAcceptInvitation(vo: HandleInvitation) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
        }
        
        let addQuery = mysql!.query(statement: """
            INSERT INTO `invitation_accept` (`invitation_id`, `group_id`, `user_id`) VALUES ('\(vo.invitationID)', '\(vo.groupID)','\(vo.userID)')
            """)
        
        let addUserQuery = mysql!.query(statement: """
            INSERT INTO `group_\(vo.groupID)`(`user_id`, `auth_level`) VALUES ('\(vo.userID)', '\(GroupAuthLevel.MEMBER.getValue())')
            """)
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `invitation` WHERE `invitation_id` = '\(vo.invitationID)'
            """)
        
        guard addQuery && addUserQuery && deleteQuery else{
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
    
    
    /// refuse invitation, delete invitation
    ///
    /// - Parameter vo: invitation id
    /// - Returns: success/fail
    func insertRefuseInvitation(vo: HandleInvitation) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        //transaction
        let transaction: Transaction = Transaction(mysql: mysql!)
        guard transaction.beginTransaction() else {
            return ReturnGenericity<String>(state: false, message: "begin transaction failed", info: "")
        }
        
        let addQuery = mysql!.query(statement: """
            INSERT INTO `invitation_refuse` (`invitation_id`, `group_id`, `user_id`) VALUES ('\(vo.invitationID)', '\(vo.groupID)','\(vo.userID)')
            """)
        
        let handleQuery = mysql!.query(statement: """
            DELETE FROM `invitation` WHERE `invitation_id` = '\(vo.invitationID)';
            """)
        guard addQuery && handleQuery else{
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
    
    /// get invitations
    ///
    /// - Parameter vo: user id
    /// - Returns: invitations
    func listInvitations(vo: UserID) -> ReturnGenericity<[InvitationInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[InvitationInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT i.`invitation_id`, i.`group_id`, i.`inviter_id`, g.`group_name` FROM `invitation` i, `group` g
            WHERE i.`invitee_id` = \(vo.userID) AND i.`group_id` = g.`group_id`
            """)
        guard getQuery else{
            return ReturnGenericity<[InvitationInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var invitation: InvitationInfo = InvitationInfo()
        var invitations: [InvitationInfo] = []
        res.forEachRow(callback: {row in
            invitation.invitationID = row[0]!
            invitation.groupID = row[1]!
            invitation.inviterID = row[2]!
            invitation.groupName = row[3]!
            invitations.append(invitation)
        })
        return ReturnGenericity<[InvitationInfo]>(state: true, message: "success", info: invitations)
    }
    
}
