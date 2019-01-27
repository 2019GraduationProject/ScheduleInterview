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
    
    func getUserInfoByID(vo: UserIDInfo) -> ReturnGenericity<Any>
    
    func getUserInfoByName(vo: UserNameInfo) -> ReturnGenericity<Any>
    
    func modifyUserInfo(vo: UserInfo) -> ReturnGenericity<Any>
}
