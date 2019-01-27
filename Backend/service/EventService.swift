//
//  EventService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

protocol EventService {
    func publishInGroupEvent(vo: NewInGroupEventInfo) -> ReturnGenericity<Any>
    
    func publishGlobalEvent(vo: NewGlobalEventInfo) -> ReturnGenericity<Any>
    
    func modifyInGroupEvent(vo: InGroupEventInfo) -> ReturnGenericity<Any>
    
    func modifyGlobalEvent(vo: GlobalEventInfo) -> ReturnGenericity<Any>
    
    func deleteEvent(vo: EventInfo) -> ReturnGenericity<Any>
    
    func findEvent(vo: EventConditions) -> ReturnGenericity<Any>
}
