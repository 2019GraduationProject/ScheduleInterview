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
    
    func deleteEvent(vo: EventID) -> ReturnGenericity<String>
    
    func deleteClause(vo: ClauseID) -> ReturnGenericity<String>
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any>
}
