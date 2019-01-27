//
//  LoginVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

struct SignupInfo {
    var password: String
    var userName: String
    var phone: String
    
    init(password: String, userName: String, phone: String) {
        self.password = password
        self.userName = userName
        self.phone = phone
    }
}

struct LoginInfo{
    var userID: String
    var password: String
    
    init(userID: String, password: String) {
        self.userID = userID
        self.password = password
    }
}

struct UserIDInfo {
    var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
}

struct UserNameInfo {
    var userName: String
    
    init(userName: String) {
        self.userName = userName
    }
}

struct UserInfo {
    var userID: String
    var password: String
    var userName: String
    var phone: String
    
    init(userID: String = "", password: String = "", userName: String = "", phone: String = "") {
        self.userID = userID
        self.password = password
        self.userName = userName
        self.phone = phone
    }
}

struct NewPasswordInfo {
    var userID: String
    var password: String
    
    init(userID: String, password: String) {
        self.userID = userID
        self.password = password
    }
}
