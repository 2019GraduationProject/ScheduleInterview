//
//  GroupService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol GroupService{
    func createGroup(vo: NewGroup) -> ReturnGenericity<String>
    
    func inviteUsers(vo: NewInvitation) -> ReturnGenericity<String>
    
    func acceptInvitation(vo: HandleInvitation) -> ReturnGenericity<String>
    
    func refuseInvitation(vo: HandleInvitation) -> ReturnGenericity<String>
    
    func getMembers(vo: GroupID) -> ReturnGenericity<[MemberInfo]>
    
    func getGroupInfo(vo: GroupID) -> ReturnGenericity<GroupInfo>
    
    func modifyGroupInfo(vo: UpdateGroup) -> ReturnGenericity<String>
    
    func dissolveGroup(vo: GroupID) -> ReturnGenericity<String>
    
    func removeMember(vo: RemoveMember) -> ReturnGenericity<String>
    
    //get group created by user
    func getCreateGroup(vo: UserID) -> ReturnGenericity<[GroupInfo]>
    
    //get group that user join in
    func getJoinGroup(vo: UserID) -> ReturnGenericity<[GroupInfo]>
    
    func getInvitations(vo: UserID) -> ReturnGenericity<[InvitationInfo]>
}
