//
//  GroupService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol GroupService{
    func createGroup(vo: NewGroupInfo) -> ReturnGenericity<String>
    
    func inviteUsers(vo: InvitationInfo) -> ReturnGenericity<String>
    
    func acceptInvitation(vo: InvitationHandleInfo) -> ReturnGenericity<String>
    
    func refuseInvitation(vo: InvitationHandleInfo) -> ReturnGenericity<String>
}
