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
    
    func createUser(vo: SignupInfo) -> ReturnGenericity<String>{
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
    
        let createQuery = mysql!.query(statement: "insert into `users` (`userName`, `password`, `phone`) values ('\(vo.userName)', '\(vo.password)', '\(vo.phone)')")
        
        guard createQuery else {
            return ReturnGenericity<String>(state: false, message: "phone exist", info: "")
        }
        
        let getQuery = mysql!.query(statement: "SELECT `userID` from users where `phone`='\(vo.phone)'")
        
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var userID: String = ""
        
        res.forEachRow { row in
            userID = row.first!!
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: userID)
    }
    
    func checkUser(vo: LoginInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: "SELECT `password` from users where `userID`='\(vo.userID)'")
        guard getQuery else {
            return ReturnGenericity<String>(state: false, message: "no such user", info: "")
        }
        
        let res = mysql!.storeResults()!
        var password: String = ""
        
        res.forEachRow { row in
            password = row.first!!
        }
        
        guard vo.password == password else{
            return ReturnGenericity<String>(state: false, message: "password wrong", info: "")
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
        
    }
    
    func getUserInfoByID(vo: UserIDInfo) -> ReturnGenericity<UserInfo> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<UserInfo>(state: false, message: "connect database failed", info: UserInfo())
        }
        
        let getQuery = mysql!.query(statement: "SELECT * from users where `userID`='\(vo.userID)'")
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
        }
        
        return ReturnGenericity<UserInfo>(info: userInfo)
    }
    
    func getUserInfoByName(vo: UserNameInfo) -> ReturnGenericity<UserInfo> {
        //TODO
        return ReturnGenericity<UserInfo>(info: UserInfo())
    }
    
    func changeUserInfo(vo: UserInfo) -> ReturnGenericity<String> {
        //TODO
        return ReturnGenericity<String>(info: "")
    }
    
    func resetPassword(vo: NewPasswordInfo) -> ReturnGenericity<String> {
        //TODO
        return ReturnGenericity<String>(info: "")
    }
}
