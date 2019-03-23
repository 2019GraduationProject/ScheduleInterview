//
//  UserService.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

protocol UserService{
    func addUser(vo: SignupInfo) -> ReturnGenericity<String>
    
    func checkUser(vo: LoginInfo) -> ReturnGenericity<String>
    
    func getUserInfoByID(vo: UserIDInfo) -> ReturnGenericity<UserInfo>
    
    func getUserInfoByName(vo: UserNameInfo) -> ReturnGenericity<UserInfo>
    
    func modifyUserInfo(vo: UserInfoChanging) -> ReturnGenericity<String>
    
    func resetPassword(vo: NewPasswordInfo) -> ReturnGenericity<String>
}
