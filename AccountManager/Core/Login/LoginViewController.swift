//
//  LoginViewController.swift
//  AccountManager
//
//  Created by Ytallo on 30/07/21.
//

import UIKit

class LoginViewController: DefaultViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passWordLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    @IBAction func loginButton(_ sender: Any) {
        
        //Recuperar dados digitados
        if let email = self.userTextField.text {
            if let password = self.passWordTextField.text {
                
                self.viewModel.Login(email: email, password: password)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        self.loginButton.clipsToBounds = true
        self.loginButton.layer.cornerRadius = 12.0
        self.loginButton.layer.borderColor = UIColor.lightGray.cgColor
        self.loginButton.layer.borderWidth = 0.5
        
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.silentLogin()
    }
    
}

extension LoginViewController: LoginViewModelDelegate{
    func didFinishWithSuccess() {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    func didFail(message: String?) {
        self.showAlert(message: message ?? "")
    }   
    
}
