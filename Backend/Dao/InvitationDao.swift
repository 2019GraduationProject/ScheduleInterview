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
    func createInvitation(vo: InvitationInfo) -> ReturnGenericity<String> {
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
    func acceptInvitation(vo: InvitationHandleInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let addQuery = mysql!.query(statement: """
            INSERT INTO `invitation_accept` (`invitation_id`, `group_id`, `user_id`) VALUES ('\(vo.invitationID)', '\(vo.groupID)','\(vo.userID)')
            """)
        guard addQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        let addUserQuery = mysql!.query(statement: """
            INSERT INTO `group_\(vo.groupID)`(`member_id`, `auth_level`) VALUES ('\(vo.userID)', '\(AuthLevel.MEMBER.getValue())')
            """)
        guard addUserQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `invitation` WHERE `invitation_id` = '\(vo.invitationID)'
            """)
        guard deleteQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// refuse invitation, delete invitation
    ///
    /// - Parameter vo: invitation id
    /// - Returns: success/fail
    func refuseInvitation(vo: InvitationHandleInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let addQuery = mysql!.query(statement: """
            INSERT INTO `invitation_refuse` (`invitation_id`, `group_id`, `user_id`) VALUES ('\(vo.invitationID)', '\(vo.groupID)','\(vo.userID)')
            """)
        guard addQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        let handleQuery = mysql!.query(statement: """
            DELETE FROM `invitation` WHERE `invitation_id` = '\(vo.invitationID)';
            """)
        guard handleQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
}
