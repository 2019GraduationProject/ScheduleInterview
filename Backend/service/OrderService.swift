//
//  OrderService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol OrderService {
    func orderClause(vo: OrderInfo) -> ReturnGenericity<Any>
  
    func cancelClause(vo: OrderInfo) -> ReturnGenericity<Any>
}
