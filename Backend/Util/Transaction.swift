//
//  Transaction.swift
//  Backend
//
//  Created by TygaG on 2019/4/22.
//

import Foundation
import PerfectMySQL

class Transaction {
    private var mysql: MySQL
    
    init(mysql: MySQL) {
        self.mysql = mysql
    }
    
    func beginTransaction() -> Bool{
        let begin = mysql.query(statement: """
            START TRANSACTION
            """)
        return begin
    }
    
    func commit() -> Bool {
        let commit = mysql.query(statement: """
            COMMIT
            """)
        return commit
    }
    
    func rollback() -> Bool {
        let rollback = mysql.query(statement: """
            ROLLBACK
            """)
        return rollback
    }
    
    func endTransaction() -> Bool{
        let end = mysql.query(statement: """
            END
            """)
        return end
    }
}
