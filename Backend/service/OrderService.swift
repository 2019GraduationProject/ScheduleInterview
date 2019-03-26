//
//  OrderService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol OrderService {
    func orderInGroupClause(vo: InGroupOrderInfo) -> ReturnGenericity<String>
    
    func orderGlobalClause(vo: GlobalOrderInfo) -> ReturnGenericity<String>
  
    func cancelInGroupClause(vo: InGroupOrderIDInfo) -> ReturnGenericity<String>
    
    func cancelGlobalClause(vo: GlobalOrderIDInfo) -> ReturnGenericity<String>
}
