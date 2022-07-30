//
//  DatabaseManager.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 31/07/2022.
//

import FirebaseDatabase

class DatabaseManager {
    
    static let shared = DatabaseManager()

    private let database = Database.database().reference()

        /// Check if email and user is available
        /// - Parameters
        ///     - email: String representing email
        ///     - username: String representing username 
    
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping(Bool) -> Void) {
        
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in 
            if error == nil {
                    // success
                completion(true)
                return
            } else {
                    // failed
                completion(false)
                return
            }
        }
    }
    
}
