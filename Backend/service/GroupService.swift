//
//  GroupService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol GroupService{
    func createGroup(vo: NewGroupInfo) -> ReturnGenericity<Any>
    
    func inviteUsers(vo: InviteUsersInfo) -> ReturnGenericity<Any>
    
    func acceptInvitation(vo: InvitationInfo) -> ReturnGenericity<Any>
    
    func refuseInvitation(vo: InvitationInfo) -> ReturnGenericity<Any>
}
