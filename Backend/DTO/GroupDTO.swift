//
//  GroupVO.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

//DB
struct Group {
    var groupID: String
    var creatorID: String
    var groupName: String
    
    init(groupID: String, creatorID:String, groupName: String) {
        self.groupID = groupID
        self.creatorID = creatorID
        self.groupName = groupName
    }
}

struct GroupInfo {
    var groupID: String
    var creatorID: String
    var groupName: String
    
    init(groupID: String = "", creatorID:String = "", groupName: String = "") {
        self.groupID = groupID
        self.creatorID = creatorID
        self.groupName = groupName
    }
}

struct NewGroup {
    var creatorID: String
    var groupName: String
    
    init(creatorID: String, groupName: String) {
        self.creatorID = creatorID
        self.groupName = groupName
    }
}

struct UpdateGroup {
    var groupID: String
    var groupName: String
    
    init(groupID: String, groupName: String) {
        self.groupID = groupID
        self.groupName = groupName
    }
}

struct GroupID {
    var groupID: String
    
    init(groupID: String) {
        self.groupID = groupID
    }
}
