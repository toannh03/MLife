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
    
    private let emailTextField: UITextField = {
        let field = UITextField() 
        field.placeholder = "Username or Email..."
        
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

}
