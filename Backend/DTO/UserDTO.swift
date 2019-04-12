//
//  LoginVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

//DB
struct User {
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

struct UserInfo {
    var userID: String
    //NO PASSWORD
    var userName: String
    var phone: String
    var gender: Bool
    var introduction: String
    
    init(userID: String = "", userName: String = "", phone: String = "", gender: Bool = true, introduction: String = "") {
        self.userID = userID
        self.userName = userName
        self.phone = phone
        self.gender = gender
        self.introduction = introduction
    }
}

struct NewUser {
    var password: String
    var userName: String
    var phone: String
    var gender: Bool
    var introduction: String
    
    init(password: String, userName: String, phone: String , gender: Bool = true, introduction: String = "") {
        self.password = password
        self.userName = userName
        self.phone = phone
        self.gender = gender
        self.introduction = introduction
    }
}

struct CheckUser {
    var phone: String
    var password: String
    
    init(phone: String, password: String) {
        self.phone = phone
        self.password = password
    }
}

struct UserID {
    var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
}

struct UserPhone {
    var phone: String
    
    init(phone: String) {
        self.phone = phone
    }
}

struct UpdateUser {
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

struct NewPassword {
    var phone: String
    var oldPass: String
    var newPass: String
    
    init(phone: String, oldPass: String, newPass: String) {
        self.phone = phone
        self.oldPass = oldPass
        self.newPass = newPass
    }
}
