//
//  UserDao.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation
import PerfectMySQL

class UserDao{
    let connector:Connector  = Connector()
    
    /// add user
    ///
    /// - Parameter vo: sign up vo
    /// - Returns: success: UserID
    func insertUser(vo: NewUser) -> ReturnGenericity<String>{
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: mysql!.errorMessage())
        }
        
        let userName: String = "user\(vo.phone)"
    
        let createQuery = mysql!.query(statement: """
            INSERT INTO `user` (`user_name`, `password`, `phone`) VALUES ('\(userName)', '\(vo.password)', '\(vo.phone)')
            """)
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "phone exist", info: mysql!.errorMessage())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `user_id` FROM `user` WHERE `phone`='\(vo.phone)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var userID: String = ""
        res.forEachRow { row in
            userID = row.first!!
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: userID)
    }
    
    /// user login
    ///
    /// - Parameter vo: log in vo
    /// - Returns: success/fail
    func getPassword(vo: CheckUser) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `password`, `user_id` FROM `user` WHERE `phone`='\(vo.phone)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "no such user", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var password: String = ""
        var userID: String = ""
        
        res.forEachRow { row in
            password = row[0]!
            userID = row[1]!
        }
        
        guard vo.password == password else{
            return ReturnGenericity<String>(state: false, message: "password wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: userID)
        
    }
    
    /// get user info by ID
    ///
    /// - Parameter vo: user id
    /// - Returns: success: userinfo
    func getUserByID(vo: UserID) -> ReturnGenericity<UserInfo> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<UserInfo>(state: false, message: "connect database failed", info: UserInfo())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `user` WHERE `user_id`='\(vo.userID)'
            """)
        guard getQuery else {
            return ReturnGenericity<UserInfo>(state: false, message: "no such user", info: UserInfo())
        }
        
        let res = mysql!.storeResults()!
        var userInfo: UserInfo = UserInfo()
        
        res.forEachRow{ row in
            userInfo.userID = row[0]!
            userInfo.userName = row[1]!
            userInfo.phone = row[3]!
            userInfo.gender = (row[4]! as NSString).boolValue
            userInfo.introduction = row[5]!
        }
        
        return ReturnGenericity<UserInfo>(state: true, message: "success", info: userInfo)
    }
    
    
    /// get user info by phone
    ///
    /// - Parameter vo: user name
    /// - Returns: success: userinfo
    func getUserByPhone(vo: UserPhone) -> ReturnGenericity<UserInfo> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<UserInfo>(state: false, message: "connect database failed", info: UserInfo())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `user` WHERE `phone`='\(vo.phone)'
            """)
        guard getQuery else {
            return ReturnGenericity<UserInfo>(state: false, message: "no such user", info: UserInfo())
        }
        
        let res = mysql!.storeResults()!
        var userInfo: UserInfo = UserInfo()
        
        res.forEachRow{ row in
            userInfo.userID = row[0]!
            userInfo.userName = row[1]!
            userInfo.phone = row[3]!
            userInfo.gender = (row[4]! as NSString).boolValue
            userInfo.introduction = row[5]!
        }
        
        return ReturnGenericity<UserInfo>(state: true, message: "success", info: userInfo)
    }
    
    
    /// change user info
    ///
    /// - Parameter vo: user info
    /// - Returns: success/fail
    func updateUser(vo: UpdateUser) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `user` SET `user_name`='\(vo.userName)', `gender`='\(vo.gender)', `introduction`='\(vo.introduction)' WHERE `user_id`='\(vo.userID)'
            """)
        guard changeQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// reset password
    ///
    /// - Parameter vo: userid, new password
    /// - Returns: success/fail
    func updatePassword(vo: NewPassword) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `password` FROM `user` WHERE `phone`='\(vo.phone)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var password: String = ""
        
        res.forEachRow { row in
            password = row[0]!
        }
        
        if vo.oldPass != password {
            return ReturnGenericity<String>(state: false, message: " old password wrong", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `user` SET `password`='\(vo.newPass)' WHERE `phone`='\(vo.phone)'
            """)
        guard changeQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }

}

