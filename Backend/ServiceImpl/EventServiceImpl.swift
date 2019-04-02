
//
//  EventServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/3/24.
//

import Foundation

class EventGroupServiceImpl: EventService{
    let eventDao: EventDao
    
    init(kind: KindOfEvent) {
        if kind == KindOfEvent.GROUP {
            eventDao = EventGroupDaoImpl()
        }else{
            eventDao = EventGlobalDaoImpl()
        }
    }
    
    func publishEvent(vo: NewEventInfo) -> ReturnGenericity<String> {
        return eventDao.createEvent(vo: vo)
    }
    
    func modifyEvent(vo: EventInfo) -> ReturnGenericity<String> {
        return eventDao.changeEventInfo(vo: vo)
    }
    
    func modifyClause(vo: ClauseInfo) -> ReturnGenericity<String> {
        return eventDao.changeClauseInfo(vo: vo)
    }

    func deleteEvent(vo: EventIDInfo) -> ReturnGenericity<String> {
        return eventDao.deleteEvent(vo: vo)
    }
    
    func deleteClause(vo: ClauseIDInfo) -> ReturnGenericity<String> {
        return eventDao.deleteClause(vo: vo)
    }
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any> {
        return eventDao.findEvent(vo: vo)
    }
}
