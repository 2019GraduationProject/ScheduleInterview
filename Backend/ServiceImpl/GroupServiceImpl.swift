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
    
    func createGroup(vo: NewGroup) -> ReturnGenericity<String> {
        return groupDao.insertGroup(vo: vo)
    }
    
    func inviteUsers(vo: NewInvitation) -> ReturnGenericity<String> {
        return invitationDao.insertInvitation(vo: vo)
    }
    
    func acceptInvitation(vo: HandleInvitation) -> ReturnGenericity<String> {
        return invitationDao.insertAcceptInvitation(vo: vo)
    }
    
    func refuseInvitation(vo: HandleInvitation) -> ReturnGenericity<String> {
        return invitationDao.insertRefuseInvitation(vo: vo)
    }
    
    func getMembers(vo: GroupID) -> ReturnGenericity<[MemberInfo]> {
        return groupDao.listMembers(vo: vo)
    }
    
    func modifyGroupInfo(vo: UpdateGroup) -> ReturnGenericity<String> {
        return groupDao.updateGroup(vo: vo)
    }
    
    func dissolveGroup(vo: GroupID) -> ReturnGenericity<String> {
        return groupDao.deleteGroup(vo: vo)
    }
    
    func removeMember(vo: RemoveMember) -> ReturnGenericity<String> {
        return groupDao.deleteMember(vo: vo)
    }
    
    
    func getCreateGroup(vo: UserID) -> ReturnGenericity<[GroupInfo]> {
        return groupDao.listCreateGroups(vo: vo)
    }
    
    func getJoinGroup(vo: UserID) -> ReturnGenericity<[GroupInfo]> {
        return groupDao.listJoinGroups(vo: vo)
    }
    
    func getInvitations(vo: UserID) -> ReturnGenericity<[InvitationInfo]> {
        return invitationDao.listInvitations(vo: vo)
    }
}
