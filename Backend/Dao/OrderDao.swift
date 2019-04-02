//
//  OrderDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/26.
//

import Foundation
import PerfectMySQL

class OrderDao{
    let connector: Connector = Connector()
    
    /// add group clause order
    ///
    /// - Parameter vo: group order
    /// - Returns: success/fail
    func createInGroupOrder(vo: InGroupOrderInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `limit`, `total`, `members` FROM `event_group_\(vo.eventID)`
        """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var limit=0
        var total=0
        var members: String = ""
        res.forEachRow { row in
            limit = Int(row[0]!)!
            total = Int(row[1]!)!
            members = row[2]!
        }
        
        total = total + 1
        if total > limit {
            return ReturnGenericity<String>(state: false, message: "full", info: "")
        }
        
        members = members + vo.userID
    
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `order_group` (`user_id`, `group_id`, `event_id`, `clause_id`)
                VALUES ('\(vo.userID)', '\(vo.groupID)', '\(vo.eventID)', '\(vo.clauseID)')
        """)
        guard insertQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let updateQuery = mysql!.query(statement: """
            UPDATE `event_group_\(vo.eventID)` SET `total` = '\(total)', `members` = '\(members)'
            """)
        guard updateQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// add global clause order
    ///
    /// - Parameter vo: global order
    /// - Returns: success/fail
    func createGlobalOrder(vo: GlobalOrderInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `limit`, `total`, `members` FROM `event_global_\(vo.eventID)`
            """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var limit=0
        var total=0
        var members: String = ""
        res.forEachRow { row in
            limit = Int(row[0]!)!
            total = Int(row[1]!)!
            members = row[2]!
        }
        
        total = total + 1
        if total > limit {
            return ReturnGenericity<String>(state: false, message: "full", info: "")
        }
        
        members = members + vo.userID
        
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `order_global` (`user_id`, `event_id`, `clause_id`)
                VALUES ('\(vo.userID)', '\(vo.eventID)', '\(vo.clauseID)')
            """)
        guard insertQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let updateQuery = mysql!.query(statement: """
            UPDATE `event_global_\(vo.eventID)` SET `total` = '\(total)', `members` = '\(members)'
            """)
        guard updateQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
    
    
    /// delete group order
    ///
    /// - Parameter vo: group order id
    /// - Returns: success/fail
    func deleteInGroupOrder(vo: InGroupOrderIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `total`, `members` FROM `event_group_\(vo.eventID)` WHERE `clause_id`  = '\(vo.clauseID)'
        """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var total=0
        var members: String = ""
        res.forEachRow { row in
            total = Int(row[0]!)!
            members = row[1]!
        }
        total = total - 1
        members = cut(members: members, member: vo.userID)
        
        let cutQuery = mysql!.query(statement: """
            UPDATE `event_group_\(vo.eventID)` SET `total` = '\(total)', `members` = '\(members)'
            """)
        guard cutQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `order_group` WHERE `order_id` = '\(vo.orderID)'
            """)
        guard deleteQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
        
    }
    
    private func cut(members: String, member: String) -> String{
        //TODO
        return members
    }
    
    
    /// delete global order
    ///
    /// - Parameter vo: global order id
    /// - Returns: success/fail
    func deleteGlobalOrder(vo: GlobalOrderIDInfo) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `total`, `members` FROM `event_global_\(vo.eventID)` WHERE `clause_id`  = '\(vo.clauseID)'
            """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var total=0
        var members: String = ""
        res.forEachRow { row in
            total = Int(row[0]!)!
            members = row[1]!
        }
        total = total - 1
        members = cut(members: members, member: vo.userID)
        
        let cutQuery = mysql!.query(statement: """
            UPDATE `event_global_\(vo.eventID)` SET `total` = '\(total)', `members` = '\(members)'
            """)
        guard cutQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let deleteQuery = mysql!.query(statement: """
            DELETE FROM `order_global` WHERE `order_id` = '\(vo.orderID)'
            """)
        guard deleteQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: "")
    }
}
