//
//  OrderService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol OrderService {
    func orderInGroupClause(vo: NewGroupOrder) -> ReturnGenericity<String>
    
    func orderGlobalClause(vo: NewGlobalOrder) -> ReturnGenericity<String>
  
    func cancelInGroupClause(vo: GroupOrderID) -> ReturnGenericity<String>
    
    func cancelGlobalClause(vo: GlobalOrderID) -> ReturnGenericity<String>
    
    func getGroupOrders(vo: UserID) -> ReturnGenericity<[GroupOrderInfo]>
    
    func getGlobalOrders(vo: UserID) -> ReturnGenericity<[GlobalOrderInfo]>
}
