
//
//  EventServiceImpl.swift
//  Backend
//
//  Created by TygaG on 2019/3/24.
//

import Foundation

class EventServiceImpl: EventService{
    let eventDao: EventDao
    
    init(kind: KindOfEvent) {
        if kind == KindOfEvent.GROUP {
            eventDao = EventGroupDaoImpl()
        }else{
            eventDao = EventGlobalDaoImpl()
        }
    }
    
    func publishEvent(vo: NewEvent) -> ReturnGenericity<String> {
        return eventDao.insertEvent(vo: vo)
    }
    
    func modifyEvent(vo: UpdateEvent) -> ReturnGenericity<String> {
        return eventDao.updateEvent(vo: vo)
    }
    
    func modifyClause(vo: UpdateClause) -> ReturnGenericity<String> {
        return eventDao.updateClause(vo: vo)
    }

    func deleteEvent(vo: EventID) -> ReturnGenericity<String> {
        return eventDao.deleteEvent(vo: vo)
    }
    
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String> {
        return eventDao.deleteClause(vo: vo)
    }
    
    func getCreateEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        return eventDao.listCreateEvent(vo: vo)
    }
    
    func getJoinEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        return eventDao.listJoinEvent(vo: vo)
    }
    
    func getAllEvent(vo: UserID) -> ReturnGenericity<[EventInfo]> {
        return eventDao.listAllEvent(vo: vo)
    }
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<[EventInfo]> {
        return eventDao.listEvents(vo: vo)
    }
}
