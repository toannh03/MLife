//
//  LoginViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit
import Lottie

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
//    var loginViewModel = LoginViewModel()
    
    // MARK: - Create view
    private let coverBackgroundLogin = UIView()
    var stackView: UIStackView!
    let animationView = AnimationView()

    private let lableLogin: UILabel = {
        let label = UILabel()
        label.text = "MLife"
        label.textAlignment = .center
        label.textColor = .black
        let font = UIFont(name: "Noteworthy-Bold", size: 50)!
        label.font = font
        return label
    }()
    
    private let imageCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "bgLogin")
        return imageView
    }()
    
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
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor( .black , for: .normal)
        let font = UIFont(name: "Noteworthy-Bold", size: 16)!
        button.titleLabel?.font = font
        button.setTitle("New user? Create an account", for: .normal)
        return button
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemBackground
        
        view.addSubview(coverBackgroundLogin)
        view.addSubview(lableLogin)
        setUpAnimationLoading()

        configureStackView()
        
        asyncLoginButton.addTarget(self, action: #selector(pressLogin), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround() 
        
        imageCover.frame = view.bounds
                
        view.insertSubview(imageCover, at: 0)
                    
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ConfigureLayoutCoverImage()
        ConfigureLayoutStackView()
        
        lableLogin.frame = CGRect(x: 0, y: stackView.frame.origin.y , width: view.frame.size.width, height: 60)
                
//        let red = CGFloat.random(in: 0...1)
//        let green = CGFloat.random(in: 0...1)
//        let blue = CGFloat.random(in: 0...1)
//        print("RGBA(\(red),\(green), \(blue))")
        
        asyncLoginButton.backgroundColor = .init(red: 0.052664157415666435,
                                                 green: 0.5005925079915937,
                                                 blue: 0.60022910677199,
                                                 alpha: 0.5)

        indicatorLogin.frame = CGRect(x: (stackView.frame.size.width / 2) - 40, y: (stackView.frame.size.height / 2) - 40, width: 80, height: 80)
    }
    
    // MARK: - Configure
    
    func setUpAnimationLoading() {
        let size: CGFloat = view.frame.size.width
        animationView.frame = CGRect(x: 0, y: view.frame.size.height - size, width: size, height: size)
        animationView.animation = Animation.named("polygons")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        imageCover.addSubview(animationView)
    }
    
    func configureStackView() {
        
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, asyncLoginButton, createAccountButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(indicatorLogin)
        coverBackgroundLogin.addSubview(stackView)
        
    }
    
    func ConfigureLayoutCoverImage() {
        
        coverBackgroundLogin.layer.masksToBounds = false
        coverBackgroundLogin.layer.cornerRadius = 20.0
        coverBackgroundLogin.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        coverBackgroundLogin.layer.shadowOpacity = 0.5
        coverBackgroundLogin.backgroundColor = .init(red: 0.5098501072066315,
                                                     green: 0.7839224830120503,
                                                     blue: 0.6957724175105579,
                                                     alpha: 0.3)
        coverBackgroundLogin.frame = CGRect(x: 30 , y: (view.frame.size.height / 2) - (view.frame.size.height / 4) + 20 , width: view.frame.size.width - 60, height: view.frame.size.height / 2)
        
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

