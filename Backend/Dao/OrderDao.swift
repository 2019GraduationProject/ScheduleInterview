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
    /// - Returns: success:order id/fail
    func insertGroupOrder(vo: NewGroupOrder) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `limit`, `total` FROM `event_group_\(vo.eventID)` WHERE `clause_id`='\(vo.clauseID)'
        """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let res = mysql!.storeResults()!
        var limit=0
        var total=0
        res.forEachRow { row in
            limit = Int(row[0]!)!
            total = Int(row[1]!)!
        }
        
        total = total + 1
        if total > limit {
            return ReturnGenericity<String>(state: false, message: "full", info: "")
        }
        
        let updateQuery = mysql!.query(statement: """
            UPDATE `event_group_\(vo.eventID)` SET `total` = '\(total)' WHERE `clause_id`='\(vo.clauseID)'
            """)
        guard updateQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `order_group` (`user_id`, `group_id`, `event_id`, `clause_id`)
            VALUES ('\(vo.userID)', '\(vo.groupID)', '\(vo.eventID)', '\(vo.clauseID)')
            """)
        guard insertQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        let getIDQuery = mysql!.query(statement: """
            SELECT `order_id` FROM `order_group`
            WHERE `user_id`='\(vo.userID)' AND `group_id`='\(vo.groupID)' AND `event_id`='\(vo.eventID)' AND `clause_id`='\(vo.clauseID)'
            """)
        guard getIDQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        let ress = mysql!.storeResults()!
        var orderID:String=""
        ress.forEachRow { row in
            orderID = row.first!!
        }
        
        return ReturnGenericity<String>(state: true, message: "success", info: orderID)
    }
    
    
    /// add global clause order
    ///
    /// - Parameter vo: global order
    /// - Returns: success/fail
    func insertGlobalOrder(vo: NewGlobalOrder) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `limit`, `total` FROM `event_global_\(vo.eventID)` WHERE `clause_id`='\(vo.clauseID)'
            """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var limit=0
        var total=0
        res.forEachRow { row in
            limit = Int(row[0]!)!
            total = Int(row[1]!)!
        }
        
        total = total + 1
        if total > limit {
            return ReturnGenericity<String>(state: false, message: "full", info: "")
        }
        
        let updateQuery = mysql!.query(statement: """
            UPDATE `event_global_\(vo.eventID)` SET `total` = '\(total)' WHERE `clause_id`='\(vo.clauseID)'
            """)
        guard updateQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        
        let insertQuery = mysql!.query(statement: """
            INSERT INTO `order_global` (`user_id`, `event_id`, `clause_id`)
            VALUES ('\(vo.userID)', '\(vo.eventID)', '\(vo.clauseID)')
            """)
        guard insertQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        let getIDQuery = mysql!.query(statement: """
            SELECT `order_id` FROM `order_group`
            WHERE `user_id`='\(vo.userID)' AND `event_id`='\(vo.eventID)' AND `clause_id`='\(vo.clauseID)'
            """)
        guard getIDQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: mysql!.errorMessage())
        }
        let ress = mysql!.storeResults()!
        var orderID:String=""
        ress.forEachRow { row in
            orderID = row.first!!
        }

        
        return ReturnGenericity<String>(state: true, message: "success", info: orderID)
    }
    
    
    /// delete group order
    ///
    /// - Parameter vo: group order id
    /// - Returns: success/fail
    func deleteGroupOrder(vo: GroupOrderID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `total` FROM `event_group_\(vo.eventID)` WHERE `clause_id`  = '\(vo.clauseID)'
        """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var total=0
        res.forEachRow { row in
            total = Int(row[0]!)!
        }
        total = total - 1
        
        let cutQuery = mysql!.query(statement: """
            UPDATE `event_group_\(vo.eventID)` SET `total` = '\(total)' WHERE `clause_id`='\(vo.clauseID)'
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
    
    
    /// delete global order
    ///
    /// - Parameter vo: global order id
    /// - Returns: success/fail
    func deleteGlobalOrder(vo: GlobalOrderID) -> ReturnGenericity<String> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<String>(state: false, message: "connect database failed", info: "")
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `total` FROM `event_global_\(vo.eventID)` WHERE `clause_id`  = '\(vo.clauseID)'
            """)
        guard getQuery else{
            return ReturnGenericity<String>(state: false, message: "database wrong", info: "")
        }
        
        let res = mysql!.storeResults()!
        var total=0
        res.forEachRow { row in
            total = Int(row[0]!)!
        }
        total = total - 1
        
        let cutQuery = mysql!.query(statement: """
            UPDATE `event_global_\(vo.eventID)` SET `total` = '\(total)' WHERE `clause_id`='\(vo.clauseID)'
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
    
    
    /// get user's group order
    ///
    /// - Parameter vo: user id
    /// - Returns: success:orders/fail
    func listGroupOrder(vo: UserID) -> ReturnGenericity<[GroupOrderInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[GroupOrderInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `order_id`,`group_id`,`event_id`,`clause_id` FROM `order_group`
            WHERE `user_id` = '\(vo.userID)'
            """)
        guard getQuery else{
            return ReturnGenericity<[GroupOrderInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var order: GroupOrderInfo = GroupOrderInfo()
        var orders: [GroupOrderInfo] = []
        res.forEachRow(callback: {row in
            order.orderID = row[0]!
            order.groupID = row[1]!
            order.eventID = row[2]!
            order.clauseID = row[3]!
            orders.append(order)
         })
        
        return ReturnGenericity<[GroupOrderInfo]>(state: true, message: "success", info: orders)
    }
    
    
    /// get user's global order
    ///
    /// - Parameter vo: user id
    /// - Returns: success:orders/fail
    func listGlobalOrder(vo: UserID) -> ReturnGenericity<[GlobalOrderInfo]> {
        let mysql: MySQL? = connector.connected()
        if mysql == nil{
            return ReturnGenericity<[GlobalOrderInfo]>(state: false, message: "connect database failed", info: [])
        }
        
        let getQuery = mysql!.query(statement: """
            SELECT `order_id`, `event_id`,`clause_id` FROM `order_global`
            WHERE `user_id` = '\(vo.userID)'
            """)
        guard getQuery else{
            return ReturnGenericity<[GlobalOrderInfo]>(state: false, message: "Wrong", info: [])
        }
        
        let res = mysql!.storeResults()!
        var order: GlobalOrderInfo = GlobalOrderInfo()
        var orders: [GlobalOrderInfo] = []
        res.forEachRow(callback: {row in
            order.orderID = row[0]!
            order.eventID = row[1]!
            order.clauseID = row[2]!
            orders.append(order)
        })
        
        return ReturnGenericity<[GlobalOrderInfo]>(state: true, message: "success", info: orders)
    }
}
