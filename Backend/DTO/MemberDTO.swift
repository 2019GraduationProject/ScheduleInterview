//
//  MemberDTO.swift
//  Backend
//
//  Created by TygaG on 2019/4/12.
//

import Foundation

//DB
struct Member {
    var memberID: String
    var userID: String
    var authLevel: GroupAuthLevel
    
    init(memberID: String, userID: String, authLevel: GroupAuthLevel) {
        self.memberID = memberID
        self.userID = userID
        self.authLevel = authLevel
    }
}

struct MemberInfo {
    var memberID: String
    var userID: String
    var authLevel: GroupAuthLevel
    
    init(memberID: String = "", userID: String = "", authLevel: GroupAuthLevel = GroupAuthLevel.MEMBER) {
        self.memberID = memberID
        self.userID = userID
        self.authLevel = authLevel
    }
}

struct RemoveMember {
    var groupID: String
    var memberID: String
    var userID: String
    
    init(groupID: String, memberID: String, userID: String) {
        self.groupID = groupID
        self.memberID = memberID
        self.userID = userID
    }
}
