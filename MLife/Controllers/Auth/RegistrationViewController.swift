//
//  RegistrationViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 31/07/2022.
//

import UIKit
import NotificationBannerSwift

class RegistrationViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
        
        // MARK: - Create view
    private let coverBackground = UIView()
    var stackView: UIStackView!
    
    lazy var indicatorRegister: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.clipsToBounds = true
        indicator.layer.cornerRadius = 8
        indicator.backgroundColor = .systemGray
        indicator.alpha = 0.6
        indicator.color = .white
        return indicator
    }()
    
    private let usernameTextField: CustomTextField = {
        let username = CustomTextField() 
        username.placeholder = "Username..."
        username.returnKeyType = .next
        username.layer.cornerRadius = Constants.cornerRadius
        return username
    }()
    
    private let emailTextField: CustomTextField = {
        let email = CustomTextField() 
        email.placeholder = "Email..."
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
    
    lazy var asyncSignInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemMint
        return button
    }()
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //        self.view.addGradientWithColor(color: UIColor.red)
        self.hideKeyboardWhenTappedAround() 
        
        configureStackView()
        
        coverBackground.frame = view.bounds
        coverBackground.addGradientWithColor(color: .random)
        view.insertSubview(coverBackground, at: 0)
        
        asyncSignInButton.addTarget(self, action: #selector(pressLogin), for: .touchUpInside)
    }
    
        // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            // Anchor function is defined in Utilities
        emailTextField.anchor(height: 50)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: view.safeAreaInsets.top + view.frame.size.height / 10, paddingLeft: 20, paddingRight: 20)
        
        indicatorRegister.frame = CGRect(x: (stackView.frame.size.width / 2) - 40, y: (stackView.frame.size.height / 2) - 40, width: 80, height: 80)
    }
    
        // MARK: - Configure
    
    func configureStackView() {
        
        stackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, asyncSignInButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(indicatorRegister)
        stackView.addSubview(indicatorRegister)
        view.addSubview(stackView)
        
    }
    
        // MARK: - Login
    
    @objc func pressLogin() {
        
        indicatorRegister.startAnimating()
        
        // Relinquish its status as the first responder in its window.
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty, 
                let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
            
            indicatorRegister.stopAnimating()
            
            floatingNotification(title: "Warning Notification", subtitle: "Please enter an email and password", titleTextAlign: .center, subtitleFont: nil, subtitleTextAlign: .center, style:.warning)
                    
            return 
        }
        
        if self.isValidEmail(email) == false {
            
            self.indicatorRegister.stopAnimating()
            self.indicatorRegister.hidesWhenStopped = true
            
            floatingNotification(title: "Warning Notification", subtitle: "Email is not valid, please try again with another email", titleTextAlign: .center, subtitleTextAlign: .center, style: .warning)
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { success in 
            DispatchQueue.main.async { [weak self] in 
                self?.handleRegistration(success: success)
            }
            self.indicatorRegister.stopAnimating()
            self.indicatorRegister.hidesWhenStopped = true
        }
        
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleRegistration(success: Bool) {
        guard success else { 
            floatingNotification(title: "Wrong Notification", subtitle: "Email already exists, please try again with another email", titleTextAlign: .center, subtitleTextAlign: .center, style: .danger)
            
            return
        }
        
        floatingNotification(title: "Success Notification", subtitle: "Successful account registration", titleTextAlign: .center, subtitleTextAlign: .center, style: .success)
                
        let tabBarSwitch = TabBarViewController()
        tabBarSwitch.modalPresentationStyle = .fullScreen
        tabBarSwitch.modalTransitionStyle = .flipHorizontal
        present(tabBarSwitch, animated: true)
    }
    
}

    // Check field when enter.

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.becomeFirstResponder()
        } else {
          //  didTapRegister()
        }
        return true 
    }
}
