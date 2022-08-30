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
    private let coverBackground = UIView()
    private let coverBackgroundLogin = UIView()
    var stackView: UIStackView!
    
    lazy var indicatorLogin: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.clipsToBounds = true
        indicator.layer.cornerRadius = 8
        indicator.backgroundColor = .systemGray
        indicator.alpha = 0.6
        indicator.color = .white
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
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemIndigo
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor( .black , for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("New user? Create an account", for: .normal)
        return button
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        
        view.addSubview(coverBackgroundLogin)
        
        view.addSubview(createAccountButton)
        coverBackgroundLogin.backgroundColor = .systemPink
        
        configureStackView()
        
        asyncLoginButton.addTarget(self, action: #selector(pressLogin), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround() 
        
        coverBackground.frame = view.bounds
        coverBackground.addGradientWithColor(color: .random)
        view.insertSubview(coverBackground, at: 0)

    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ConfigureLayoutCoverImage()
        ConfigureLayoutStackView()
        
        createAccountButton.centerX(with: self.coverBackgroundLogin, topAnchor: coverBackgroundLogin.bottomAnchor, paddingTop: 10)
            
        indicatorLogin.frame = CGRect(x: (stackView.frame.size.width / 2) - 40, y: (stackView.frame.size.height / 2) - 40, width: 80, height: 80)
    }
    
    // MARK: - Configure
    
    func configureStackView() {
        
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, asyncLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(indicatorLogin)
        coverBackgroundLogin.addSubview(stackView)
        
    }
    
    func ConfigureLayoutCoverImage() {
        coverBackgroundLogin.layer.masksToBounds = false
        coverBackgroundLogin.layer.cornerRadius = 8.0
        coverBackgroundLogin.layer.shadowOffset = CGSize(width: 2, height: 2)
        coverBackgroundLogin.layer.shadowOpacity = 3.0
        coverBackgroundLogin.backgroundColor = .systemTeal
        coverBackgroundLogin.frame = CGRect(x: 10 , y: view.frame.size.height / 2 - 100 , width: view.frame.size.width - 20, height: 200)
        
    }
    
    func ConfigureLayoutStackView() {
        emailTextField.anchor(height: 46)
        stackView.centerX(with: coverBackgroundLogin)
        stackView.centerY(withView: coverBackgroundLogin)
        stackView.anchor(left: coverBackgroundLogin.leftAnchor, right: coverBackgroundLogin.rightAnchor, paddingLeft: 10, paddingRight: 10)
    }
    
    // MARK: - Login
    
    @objc func pressLogin() {
        
        indicatorLogin.startAnimating()

        // Relinquish its status as the first responder in its window.
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else { 
            indicatorLogin.stopAnimating()
            floatingNotification(title: "Warning Notification", subtitle: "Please enter an email and password", titleTextAlign: .center, subtitleFont: nil, subtitleTextAlign: .center, style:.warning)
            return 
        }
        
        if self.isValidEmail(email) == false {
            
            self.indicatorLogin.stopAnimating()
            self.indicatorLogin.hidesWhenStopped = true
            
            floatingNotification(title: "Warning Notification", subtitle: "Email is not valid, please try again with another email", titleTextAlign: .center, subtitleTextAlign: .center, style: .warning)
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
            floatingNotification(title: "Error Notification", subtitle: "Something went wrong when signing in", titleTextAlign: .center, subtitleTextAlign: .center, style: .danger)
            return
        }
        
        floatingNotification(title: "Sccessful Login!", titleTextAlign: .center, style: .success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let tabBarSwitch = TabBarViewController()
            tabBarSwitch.modalPresentationStyle = .fullScreen
            tabBarSwitch.modalTransitionStyle = .flipHorizontal
            self.present(tabBarSwitch, animated: true)
        })
    }
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title =  "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .always
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.navigationBar.prefersLargeTitles = true
        present(rootVC, animated: true)
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

