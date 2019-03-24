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
            INSERT INTO `invitation` (`groupID`, `inviterID`, `inviteeID`) VALUES ('\(vo.groupID)', '\(vo.inviterID)', '\(vo.inviteeID)')
            """)
        
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "Wrong", info: "")
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
        
        let handleQuery = mysql!.query(statement: """
            DELETE FROM `invitation` WHERE `invitationID` = \(vo.invitationID);
            INSERT INTO `group_\(vo.groupID)`(`memberID`, `authLv`) VALUES (\(vo.userID), \(AuthLevel.MEMBER));
            """)
        guard handleQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// refuse invitation, delete invitation
    ///
    /// - Parameter vo: invitation id
    /// - Returns: success/fail
    func refuseInvitation(vo: InvitationIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let handleQuery = mysql!.query(statement: """
            DELETE FROM `invitation` WHERE `invitationID` = \(vo.invitationID);
            """)
        guard handleQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
}
