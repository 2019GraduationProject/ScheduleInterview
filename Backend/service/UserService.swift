//
//  UserService.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

protocol UserService{
    func addUser(vo: NewUser) -> ReturnGenericity<String>
    
    func checkUser(vo: CheckUser) -> ReturnGenericity<String>
    
    func getUserInfoByID(vo: UserID) -> ReturnGenericity<UserInfo>
    
    func getUserInfoByPhone(vo: UserPhone) -> ReturnGenericity<UserInfo>
    
    func modifyUserInfo(vo: UpdateUser) -> ReturnGenericity<String>
    
    func resetPassword(vo: NewPassword) -> ReturnGenericity<String>
    
    func getInvitations(vo: UserID) -> ReturnGenericity<[InvitationInfo]>
    
    func getCreateGroup(vo: UserID) -> ReturnGenericity<[GroupInfo]>
    
    func getJoinGroup(vo: UserID) -> ReturnGenericity<[GroupInfo]>
}
