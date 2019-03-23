//
//  LoginVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

struct SignupInfo {
    var password: String
    var phone: String
    
    init(password: String, phone: String) {
        self.password = password
        self.phone = phone
    }
}

struct LoginInfo{
    var phone: String
    var password: String
    
    init(phone: String, password: String) {
        self.phone = phone
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
    var gender: Bool
    var introduction: String
    
    init(userID: String = "", password: String = "", userName: String = "", phone: String = "", gender: Bool = true, introduction: String = "") {
        self.userID = userID
        self.password = password
        self.userName = userName
        self.phone = phone
        self.gender = gender
        self.introduction = introduction
    }
}

struct UserInfoChanging {
    var userID: String
    var userName: String
    var gender: Bool
    var introduction: String
    
    init(userID: String = "", userName: String = "", gender: Bool, introduction: String) {
        self.userID = userID
        self.userName = userName
        self.gender = gender
        self.introduction = introduction
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
