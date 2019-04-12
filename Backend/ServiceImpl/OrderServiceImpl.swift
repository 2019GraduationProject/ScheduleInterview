//
//  OrderServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/3/26.
//

import Foundation

class OrderServiceImpl: OrderService{
    let orderDao: OrderDao = OrderDao()
    
    func orderInGroupClause(vo: NewGroupOrder) -> ReturnGenericity<String> {
        return orderDao.insertGroupOrder(vo: vo)
    }
    
    func orderGlobalClause(vo: NewGlobalOrder) -> ReturnGenericity<String> {
        return orderDao.insertGlobalOrder(vo:vo)
    }
    
    func cancelInGroupClause(vo: GroupOrderID) -> ReturnGenericity<String> {
        return orderDao.deleteGroupOrder(vo:vo)
    }
    
    func cancelGlobalClause(vo: GlobalOrderID) -> ReturnGenericity<String> {
        return orderDao.deleteGlobalOrder(vo:vo)
    }
}
