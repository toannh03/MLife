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
    
    // MARK: - Create view
    
    var stackView: UIStackView!
    
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
        
        view.backgroundColor = .systemBackground
        self.hideKeyboardWhenTappedAround() 
        view.addSubview(createAccountButton)
        
        // Configure stack 
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, asyncLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Anchor function is defined in Utilities
        emailTextField.anchor(height: 50)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: view.safeAreaInsets.top + view.frame.size.height / 3.5, paddingLeft: 20, paddingRight: 20)
        createAccountButton.centerX(with: stackView, topAnchor: stackView.bottomAnchor, paddingTop: 10)
        
    }
}

    // Hiden keyboard when you tap everywhere in UIView
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
