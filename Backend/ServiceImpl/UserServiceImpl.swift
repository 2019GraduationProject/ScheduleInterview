//
//  UserServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

class UserServiceImpl: UserService {
    
    let userDao = UserDao()
    
    func addUser(vo: SignupInfo) -> ReturnGenericity<String> {
        return userDao.createUser(vo: vo)
    }
    
    func checkUser(vo: LoginInfo) -> ReturnGenericity<String> {
        return userDao.checkUser(vo: vo)
    }

    func getUserInfoByID(vo: UserIDInfo) -> ReturnGenericity<UserInfo> {
        return userDao.getUserInfoByID(vo:vo)
    }

    func getUserInfoByName(vo: UserNameInfo) -> ReturnGenericity<UserInfo> {
        return userDao.getUserInfoByName(vo: vo)
    }

    func modifyUserInfo(vo: UserInfoChanging) -> ReturnGenericity<String> {
       return userDao.changeUserInfo(vo:vo)
    }

    func resetPassword(vo: NewPasswordInfo) -> ReturnGenericity<String> {
        return userDao.resetPassword(vo:vo)
    }
}
