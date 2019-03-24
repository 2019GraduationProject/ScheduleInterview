//
//  GroupVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

struct NewGroupInfo {
    var userID: String
    var groupName: String
    var introduction: String
    
    init(userID: String, groupName: String, introduction: String) {
        self.userID = userID
        self.groupName = groupName
        self.introduction = introduction
    }
}

struct GroupInfoChanging {
    
}

struct InvitationInfo {
    var groupID: String
    var inviterID: String
    var inviteeID: String
    
    init(groupID: String, inviterID: String, inviteeID: String) {
        self.groupID = groupID
        self.inviterID = inviterID
        self.inviteeID = inviteeID
    }
}

struct InvitationHandleInfo {
    var invitationID: String
    var groupID: String
    var userID: String
    
    init(invitationID: String, groupID: String, userID: String) {
        self.invitationID = invitationID
        self.groupID = groupID
        self.userID = userID
    }
}

struct InvitationIDInfo {
    var invitationID: String
    
    init(invitationID: String) {
        self.invitationID = invitationID
    }
}
