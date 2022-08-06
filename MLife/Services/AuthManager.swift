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
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    // MARK: - LOGIN
    
    func login(username: String? ,email: String?, password: String, completion: @escaping(Bool) -> Void) {
        if let email = email {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in 
                
                guard let auth = authResult ,authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                auth.user.getIDTokenForcingRefresh(true) { idToken, error in
                                        
                    guard let access_token = idToken, error == nil else { return }
            
                    UserDefaults.standard.setValue(access_token, forKey: "access_token")   
                    
                    Auth.auth().signIn(withCustomToken: access_token)
                    
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
                    
                    guard let id = result?.user.uid else { return }
                    
                        // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username, id: id) { success in 
                        if success {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                ///////
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
