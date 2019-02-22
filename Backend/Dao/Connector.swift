//
//  Connector.swift
//  Backend
//
//  Created by TygaG on 2019/1/6.
//

import Foundation
import PerfectMySQL

final class Connector{
    init() {
    }
    
    private let host = "127.0.0.1"
    private let user = "root"
    private let password = "root123456"
    private let DB = "ScheduleInterview"
    
    func connected() ->  MySQL?{
        let mysql: MySQL = MySQL()
        let connected = mysql.connect(host: host, user: user, password: password, db: DB)
        
        guard connected else {
            print(mysql.errorMessage())
            return nil
        }
        return mysql
    }

    deinit {
    }
}
