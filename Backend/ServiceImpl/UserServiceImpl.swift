//
//  UserServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

class UserServiceImpl: UserService {
    
    let userDao = UserDao()
    
    func addUser(vo: NewUser) -> ReturnGenericity<String> {
        return userDao.insertUser(vo: vo)
    }
    
    func checkUser(vo: CheckUser) -> ReturnGenericity<String> {
        return userDao.getPassword(vo: vo)
    }

    func getUserInfoByID(vo: UserID) -> ReturnGenericity<UserInfo> {
        return userDao.getUserByID(vo:vo)
    }

    func getUserInfoByPhone(vo: UserPhone) -> ReturnGenericity<UserInfo> {
        return userDao.getUserByPhone(vo: vo)
    }

    func modifyUserInfo(vo: UpdateUser) -> ReturnGenericity<String> {
       return userDao.updateUser(vo:vo)
    }

    func resetPassword(vo: NewPassword) -> ReturnGenericity<String> {
        return userDao.updatePassword(vo:vo)
    }
    
}
