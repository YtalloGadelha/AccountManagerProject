//
//  LoginViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didFinishWithSuccess()
    func didFail(message: String?)
}

class LoginViewModel {
    
    private let businessModel: LoginProtocol
    weak var delegate: LoginViewModelDelegate?
    
    init(businessModel: LoginProtocol = LoginBusinessModel()) {
        self.businessModel = businessModel
    }
    
    func Login(email: String, password: String) {
        self.businessModel.login(credentials: LoginCredentials(email: email, password: password)) { [weak self] result in
            switch result {
                
            case .success(_):
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
    func silentLogin() {
        if LoginBusinessModel.isLogged() {
            self.delegate?.didFinishWithSuccess()
        }
    }
}
