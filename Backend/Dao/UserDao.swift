//
//  UserDao.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation
import PerfectMySQL

class UserDao{
    let connector:Connector = Connector()

    
    /// add user
    ///
    /// - Parameter vo: sign up vo
    /// - Returns: success: UserID
    func createUser(vo: SignupInfo) -> ReturnGenericity<String>{
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let userName: String = "user\(vo.phone)"
    
        let createAndGetQuery = mysql!.query(statement: """
            INSERT INTO `users` (`userName`, `password`, `phone`) VALUES ('\(userName)', '\(vo.password)', '\(vo.phone)');
            SELECT `userID` FROM `users` WHERE `phone`='\(vo.phone)';
            """)
        guard createAndGetQuery else {
            return ReturnGenericity<String>(state: false, message: "phone exist or database wrong", info: "")
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
    func checkUser(vo: LoginInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `password`, `userID` FROM `users` WHERE `phone`='\(vo.phone)'
            """)
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "no such user", info: "")
        }
        
        let res = mysql!.storeResults()!
        var password: String = ""
        var userID: String = ""
        
        res.forEachRow { row in
            password = row[0]!
            userID = row[1]!
        }
        
        guard vo.password == password else{
            return ReturnGenericity<String>(state: false, message: "password wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: userID)
        
    }
    
    /// get user info by ID
    ///
    /// - Parameter vo: user id
    /// - Returns: success: userinfo
    func getUserInfoByID(vo: UserIDInfo) -> ReturnGenericity<UserInfo> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<UserInfo>(state: false, message: "connect database failed", info: UserInfo())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `users` WHERE `userID`='\(vo.userID)'
            """)
        guard getQuery else {
            return ReturnGenericity<UserInfo>(state: false, message: "no such user", info: UserInfo())
        }
        
        let res = mysql!.storeResults()!
        var userInfo: UserInfo = UserInfo()
        
        res.forEachRow{ row in
            userInfo.userID = row[0]!
            userInfo.userName = row[1]!
            userInfo.password = row[2]!
            userInfo.phone = row[3]!
            userInfo.gender = (row[4]! as NSString).boolValue
            userInfo.introduction = row[5]!
        }
        
        return ReturnGenericity<UserInfo>(state: true, message: "success", info: userInfo)
    }
    
    
    /// get user info by name
    ///
    /// - Parameter vo: user name
    /// - Returns: success: userinfo
    func getUserInfoByName(vo: UserNameInfo) -> ReturnGenericity<UserInfo> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<UserInfo>(state: false, message: "connect database failed", info: UserInfo())
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT * FROM `users` WHERE `userName`='\(vo.userName)'
            """)
        guard getQuery else {
            return ReturnGenericity<UserInfo>(state: false, message: "no such user", info: UserInfo())
        }
        
        let res = mysql!.storeResults()!
        var userInfo: UserInfo = UserInfo()
        
        res.forEachRow{ row in
            userInfo.userID = row[0]!
            userInfo.userName = row[1]!
            userInfo.password = row[2]!
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
    func changeUserInfo(vo: UserInfoChanging) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `users` SET `userName`='\(vo.userName)', `gender`='\(vo.gender)', `introduction`='\(vo.introduction)' WHERE `userID`='\(vo.userID)'
            """)
        guard changeQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// reset password
    ///
    /// - Parameter vo: userid, new password
    /// - Returns: success/fail
    func resetPassword(vo: NewPasswordInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let changeQuery = mysql!.query(statement: """
            UPDATE `users` SET `password`='\(vo.password)' WHERE `userID`='\(vo.userID)'
            """)
        guard changeQuery else{
            return ReturnGenericity<String>(state: false, message: "Wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
}
