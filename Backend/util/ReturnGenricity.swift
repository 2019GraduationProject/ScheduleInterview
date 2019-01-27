//
//  ReturnGenericity.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation

// 返回数据类型封装
struct ReturnGenericity<T> {
    var state: Bool
    var message: String
    var info: T
    
    init(state: Bool = false, message: String = "", info: T) {
        self.state = state
        self.message = message
        self.info = info
    }
}
