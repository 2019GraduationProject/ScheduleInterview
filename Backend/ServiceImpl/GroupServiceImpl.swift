//
//  GroupServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/3/23.
//

import Foundation

class GroupServiceImpl: GroupService{
    let groupDao = GroupDao()
    let invitationDao = InvitationDao()
    
    func createGroup(vo: NewGroupInfo) -> ReturnGenericity<String> {
        return groupDao.createGroup(vo: vo)
    }
    
    func inviteUsers(vo: InvitationInfo) -> ReturnGenericity<String> {
        return invitationDao.createInvitation(vo: vo)
    }
    
    func acceptInvitation(vo: InvitationHandleInfo) -> ReturnGenericity<String> {
        return invitationDao.acceptInvitation(vo: vo)
    }
    
    func refuseInvitation(vo: InvitationHandleInfo) -> ReturnGenericity<String> {
        return invitationDao.refuseInvitation(vo: vo)
    }
    
    
}
