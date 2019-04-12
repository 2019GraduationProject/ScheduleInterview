//
//  EventService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol EventService {
    func publishEvent(vo: NewEvent) -> ReturnGenericity<String>
    
    func modifyEvent(vo: UpdateEvent) -> ReturnGenericity<String>
    
    func modifyClause(vo: UpdateClause) -> ReturnGenericity<String>
    
    //TODO
    func addClause(vo: NewClause) -> ReturnGenericity<String>
    
    func deleteEvent(vo: EventID) -> ReturnGenericity<String>
    
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String>
    
    func getCreateEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func getJoinEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    func getAllEvent(vo: UserID) -> ReturnGenericity<[EventInfo]>
    
    //TODO
    func getClauses(vo: EventID) -> ReturnGenericity<[ClauseInfo]>
    
    //TODO
    func findEvent(vo: EventConditions) -> ReturnGenericity<[EventInfo]>
}
