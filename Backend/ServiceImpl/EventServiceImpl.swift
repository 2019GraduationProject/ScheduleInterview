
//
//  EventServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/3/24.
//

import Foundation

class EventServiceImpl: EventService{
    let eventDao: EventDao = EventDao()
    
    func publishInGroupEvent(vo: NewInGroupEventInfo) -> ReturnGenericity<String> {
        return eventDao.createInGroupEvent(vo: vo)
    }
    
    func publishGlobalEvent(vo: NewGlobalEventInfo) -> ReturnGenericity<String> {
        return eventDao.createGlobalEvent(vo: vo)
    }
    
    func modifyInGroupEvent(vo: InGroupEventInfo) -> ReturnGenericity<String> {
        return eventDao.changeInGroupEventInfo(vo: vo)
    }
    
    func modifyGlobalEvent(vo: GlobalEventInfo) -> ReturnGenericity<String> {
        return eventDao.changeGlobalEventInfo(vo: vo)
    }
    
    func modifyInGroupClause(vo: InGroupClauseInfo) -> ReturnGenericity<String> {
        return eventDao.changeInGroupClausetInfo(vo: vo)
    }
    
    func modifyGlobalClause(vo: GlobalClauseInfo) -> ReturnGenericity<String> {
        return eventDao.changeGlobalClauseInfo(vo: vo)
    }
    
    func deleteInGroupEvent(vo: InGroupEventIDInfo) -> ReturnGenericity<String> {
        return eventDao.deleteInGroupEvent(vo: vo)
    }
    
    func deleteGlobalEvent(vo: GlobalEventIDInfo) -> ReturnGenericity<String> {
        return eventDao.deleteGlobalEvent(vo: vo)
    }
    
    func deleteInGroupClause(vo: InGroupClauseIDInfo) -> ReturnGenericity<String> {
        return eventDao.deleteInGroupClause(vo: vo)
    }
    
    func deleteGlobalClause(vo: GlobalClauseIDInfo) -> ReturnGenericity<String> {
        return eventDao.deleteGlobalClause(vo: vo)
    }
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any> {
        return eventDao.findEvent(vo: vo)
    }
    
    
}
