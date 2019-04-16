//
//  UserService.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

protocol UserService{
    //Sign up
    func addUser(vo: NewUser) -> ReturnGenericity<String>
    
    //after sign up
    func getUserIDByPhone(vo: UserPhone) -> ReturnGenericity<String>
    
    //Log in
    func checkUser(vo: CheckUser) -> ReturnGenericity<String>
    
    //get user info
    func getUserInfoByID(vo: UserID) -> ReturnGenericity<UserInfo>
    
    func getUserInfoByPhone(vo: UserPhone) -> ReturnGenericity<UserInfo>
    
    //change user info (without password)
    func modifyUserInfo(vo: UpdateUser) -> ReturnGenericity<String>
    
    //reset password
    func resetPassword(vo: NewPassword) -> ReturnGenericity<String>

}
