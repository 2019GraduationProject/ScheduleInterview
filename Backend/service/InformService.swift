//
//  InformService.swift
//  Backend
//
//  Created by TygaG on 2019/1/16.
//

import Foundation

//对上层隐藏
protocol InformService {
    func informInvitation(vo: InvitationInformInfo) -> ReturnGenericity<Any>
    
    func informInGroupEvent(vo: InGroupEventInformInfo) -> ReturnGenericity<Any>
    
    func informGlobalEvent(vo: GlobalEventInformInfo) -> ReturnGenericity<Any>
}
