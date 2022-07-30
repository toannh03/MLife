//
//  LoginViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
//    var loginViewModel = LoginViewModel()
    
    // MARK: - Create view
    
    var stackView: UIStackView!
    
    lazy var indicatorLogin: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .systemTeal
        return indicator
    }()
    
    private let emailTextField: CustomTextField = {
        let email = CustomTextField() 
        email.placeholder = "Username or Email..."
        email.returnKeyType = .next
        email.layer.cornerRadius = Constants.cornerRadius
        return email
    }()
    
    private let passwordTextField: CustomTextField = {
        let password = CustomTextField()
        password.placeholder = "Password..."
        password.returnKeyType = .continue
        password.layer.cornerRadius = Constants.cornerRadius
        password.isSecureTextEntry = true
        return password
    }()
    
    lazy var asyncLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemIndigo
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("New user? Create an account", for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGradientWithColor(color: UIColor.red)
        
        self.hideKeyboardWhenTappedAround() 
        view.addSubview(createAccountButton)
        
        configureStackView()
        
        asyncLoginButton.addTarget(self, action: #selector(pressLogin), for: .touchUpInside)
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Anchor function is defined in Utilities
        emailTextField.anchor(height: 50)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: view.safeAreaInsets.top + view.frame.size.height / 3.5, paddingLeft: 20, paddingRight: 20)
        createAccountButton.centerX(with: stackView, topAnchor: stackView.bottomAnchor, paddingTop: 10)
        
        indicatorLogin.frame = CGRect(x: (stackView.frame.size.width / 2) - 25, y: (stackView.frame.size.height / 2) - 25, width: 50, height: 50)
    }
    
    // MARK: - Configure
    
    func configureStackView() {
        
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, asyncLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(indicatorLogin)
        stackView.addSubview(indicatorLogin)
        view.addSubview(stackView)
        
    }
    
    // MARK: - Login
    
    @objc func pressLogin() {
        
        indicatorLogin.startAnimating()

        // Relinquish its status as the first responder in its window.
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else { 
            indicatorLogin.stopAnimating()
            let notification = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Dismis", style: .cancel, handler: nil)
            notification.addAction(defaultAction)
            self.present(notification, animated: true, completion: nil)
            return 
        }
        
        if self.isValidEmail(email) == false {
            
            self.indicatorLogin.stopAnimating()
            self.indicatorLogin.hidesWhenStopped = true
            
            let notification = UIAlertController(title: "Error", message: "Email is not valid", preferredStyle: .alert)
            notification.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(notification, animated: true, completion: nil)
            return
        }
        
        var emailUser: String?
        var userName: String?
        
        if email.contains("@"), email.contains(".") {
            emailUser = email
        } else {
            userName = email
        }
        
        AuthManager.shared.login(username: userName, email: emailUser, password: password) { success in 
            DispatchQueue.main.async { [weak self] in 
                self?.handleSignIn(success: success)
            }
            self.indicatorLogin.stopAnimating()
            self.indicatorLogin.hidesWhenStopped = true
        }
        
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else { 
            let alert = UIAlertController(title: "Error", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            return
        }
        
        let tabBarSwitch = TabBarViewController()
        tabBarSwitch.modalPresentationStyle = .fullScreen
        tabBarSwitch.modalTransitionStyle = .flipHorizontal
        present(tabBarSwitch, animated: true)
    }
    
}

    // MARK: - Extension

    // Hiden keyboard when you tap everywhere in UIView.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false            
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

    // Check field when enter.
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            pressLogin()
        }
        return true
    }
}

