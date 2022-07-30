//
//  AuthManager.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 29/07/2022.
//

import FirebaseAuth

class AuthManager {
    
    // Singletion
    static let shared = AuthManager()
    
    private init() {}
    
    // MARK: - LOGIN
    
    func login(username: String? ,email: String?, password: String, completion: @escaping(Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in 
                
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }    
        } else {
            completion(false)
        }
    }
    
    // MARK: - REGISTRATION
    
    func registerNewUser(username: String, email: String, password: String, completion: @escaping(Bool) -> ()) {
        /* 
         - Create account 
         - Insert account to database
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /* 
                 - Create account 
                 - Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { result, error in 
                    
                    guard result != nil, error == nil else { 
                            // Firebase auth could not create account
                        completion(false)
                        return 
                        
                    }
                    
                        // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { success in 
                        if success {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                    // email or password does not exit
                completion(false)
            }
        }
    }
    
    // MARK: - LOGOUT
    
    func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            completion(false)
            print(error)
            return
        }
    }
    
}
