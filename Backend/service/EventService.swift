//
//  EventService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol EventService {
    func publishInGroupEvent(vo: NewInGroupEventInfo) -> ReturnGenericity<String>
    
    func publishGlobalEvent(vo: NewGlobalEventInfo) -> ReturnGenericity<String>
    
    func modifyInGroupEvent(vo: InGroupEventInfo) -> ReturnGenericity<String>
    
    func modifyGlobalEvent(vo: GlobalEventInfo) -> ReturnGenericity<String>
    
    func modifyInGroupClause(vo: InGroupClauseInfo) -> ReturnGenericity<String>
    
    func modifyGlobalClause(vo: GlobalClauseInfo) -> ReturnGenericity<String>
    
    func deleteInGroupEvent(vo: InGroupEventIDInfo) -> ReturnGenericity<String>
    
    func deleteGlobalEvent(vo: GlobalEventIDInfo) -> ReturnGenericity<String>
    
    func deleteInGroupClause(vo: InGroupClauseIDInfo) -> ReturnGenericity<String>
    
    func deleteGlobalClause(vo: GlobalClauseIDInfo) -> ReturnGenericity<String>
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any>
}
