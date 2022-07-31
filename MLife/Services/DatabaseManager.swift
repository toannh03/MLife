//
//  DatabaseManager.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 31/07/2022.
//

import FirebaseDatabase
import FirebaseAuth

class DatabaseManager {
    
    static let shared = DatabaseManager()

    private let database = Database.database().reference()

        /// Check if email and user is available
        /// - Parameters
        ///     - email: String representing email
        ///     - username: String representing username 
    
    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(email.safeDatabaseKey()) {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    public func insertNewUser(with email: String, username: String, id: String, completion: @escaping(Bool) -> Void) {
    
        database.child("users").setValue(["id": id, "username": username, "email": email.safeDatabaseKey()]) { error, _ in 
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
