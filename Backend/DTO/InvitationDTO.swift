//
//  InvitationDTO.swift
//  Backend
//
//  Created by TygaG on 2019/4/12.
//

import Foundation

//DB
struct Invitation {
    var invitationID: String
    var groupID: String
    var inviterID: String
    var inviteeID: String
    
    init(invitationID:String, groupID: String, inviterID: String, inviteeID: String) {
        self.invitationID = invitationID
        self.groupID = groupID
        self.inviterID = inviterID
        self.inviteeID = inviteeID
    }
}

struct InvitationInfo {
    var invitationID: String
    var groupID: String
    var inviterID: String
    
    init(invitationID:String = "", groupID: String = "", inviterID: String = "") {
        self.invitationID = invitationID
        self.groupID = groupID
        self.inviterID = inviterID
    }
}

struct NewInvitation {
    var groupID: String
    var inviterID: String
    var inviteeID: String
    
    init(groupID: String, inviterID: String, inviteeID: String) {
        self.groupID = groupID
        self.inviterID = inviterID
        self.inviteeID = inviteeID
    }
}

struct HandleInvitation {
    var invitationID: String
    var groupID: String
    var userID: String
    
    init(invitationID: String, groupID: String, userID: String) {
        self.invitationID = invitationID
        self.groupID = groupID
        self.userID = userID
    }
}
