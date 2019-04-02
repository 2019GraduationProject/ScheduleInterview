//
//  EventService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol EventService {
    func publishEvent(vo: NewEventInfo) -> ReturnGenericity<String>
    
    func modifyEvent(vo: EventInfo) -> ReturnGenericity<String>
    
    func modifyClause(vo: ClauseInfo) -> ReturnGenericity<String>
    
    func deleteEvent(vo: EventIDInfo) -> ReturnGenericity<String>
    
    func deleteClause(vo: ClauseIDInfo) -> ReturnGenericity<String>
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any>
}
