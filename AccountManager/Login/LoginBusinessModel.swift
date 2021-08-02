//
//  LoginBusinessModel.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation
import FirebaseAuth

fileprivate var globalUser: User? = nil

class LoginBusinessModel: LoginProtocol {
    
    func login(credentials: LoginCredentials, completion: @escaping(Result<Void, AccountManagerError>) -> Void) {
        //Autenticar usuário no Firebase
        let autenticacao = Auth.auth()
        autenticacao.signIn(withEmail: credentials.email, password: credentials.password, completion: { (user, error) in
            
            if error == nil {
                
                if let email = user?.user.email {
                    
                    globalUser = User(email: email)
                    completion(.success(()))
                    
                }else{
                    globalUser = nil
                    completion(.failure(.auth))
                }
                
            }else{
                globalUser = nil
                completion(.failure(.auth))
            }
        })
    }
    
    func logout(completion: @escaping(Result<Void, AccountManagerError>) -> Void) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            globalUser = nil
            completion(.success(()))
        } catch {
            completion(.failure(.signout))
        }
    }
    
    static func isLogged() -> Bool{
        
        guard let _ = globalUser else {
            return false
        }
        
        return true
    }
}
