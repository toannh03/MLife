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
