//
//  OrderServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/3/26.
//

import Foundation

class OrderServiceImpl: OrderService{
    let orderDao: OrderDao = OrderDao()
    
    func orderInGroupClause(vo: InGroupOrderInfo) -> ReturnGenericity<String> {
        return orderDao.createInGroupOrder(vo: vo)
    }
    
    func orderGlobalClause(vo: GlobalOrderInfo) -> ReturnGenericity<String> {
        return orderDao.createGlobalOrder(vo:vo)
    }
    
    func cancelInGroupClause(vo: InGroupOrderIDInfo) -> ReturnGenericity<String> {
        return orderDao.deleteInGroupOrder(vo:vo)
    }
    
    func cancelGlobalClause(vo: GlobalOrderIDInfo) -> ReturnGenericity<String> {
        return orderDao.deleteGlobalOrder(vo:vo)
    }
}
