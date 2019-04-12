//
//  EventDao.swift
//  Backend
//
//  Created by TygaG on 2019/3/25.
//

import Foundation

protocol EventDao{
    func insertEvent(vo: NewEvent) -> ReturnGenericity<String>
    
    func updateEvent(vo: UpdateEvent) -> ReturnGenericity<String>
    
    func updateClause(vo: UpdateClause) -> ReturnGenericity<String>
    
    func insertClause(vo: NewClause) -> ReturnGenericity<String>
    
    func deleteEvent(vo: EventID) -> ReturnGenericity<String>
    
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String>
    
    func listCreateEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func listJoinEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func listAllEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func listClause(vo: EventID) -> ReturnGenericity<[ClauseInfo]>
    
    func listEvents(vo: EventConditions) -> ReturnGenericity<[EventInfo]>
}
