//
//  ProfileViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    private let imageProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bgLogin")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let idUser: UILabel = {
        let lable = UILabel()
        lable.textColor = .label
        lable.textAlignment = .center
        lable.font = UIFont(name: "Avenir-Black", size: 17)
        return lable
    }()
    
    private let nameUser: UILabel = {
        let lable = UILabel()
        lable.textColor = .label
        lable.textAlignment = .center
        lable.font = UIFont(name: "Avenir-Black", size: 20)
        return lable
    }()
    
    private let buttonLogOut: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.layer.masksToBounds = true
        button.backgroundColor = .label
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addGradientWithColor(color: .random)
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.addSubview(nameUser)
        view.addSubview(idUser)
        buttonLogOut.addTarget(self, action: #selector(LogOut), for: .touchUpInside)
        fetchingUserInfo()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = 100
        let sizeWidth: CGFloat = view.frame.size.width / 2
        imageProfile.frame = CGRect(x: sizeWidth - (size/2), y: sizeWidth - (size/2), width: size, height: size)
        imageProfile.layer.cornerRadius = size / 2
        idUser.frame = CGRect(x: 0, y: imageProfile.frame.origin.y + size + 10, width: sizeWidth * 2, height: 50)
        nameUser.frame = CGRect(x: 0, y: idUser.frame.origin.y + 60, width: sizeWidth * 2, height: 50)

        buttonLogOut.frame = CGRect(x: sizeWidth - 50, y: nameUser.frame.origin.y + 60, width: 100, height: 50)   
        buttonLogOut.layer.cornerRadius = 25
    }
    
    func fetchingUserInfo() {
        
        let defaults = UserDefaults.standard
        
        AuthManager.shared.getUserInfo { [self] success in
            if success {
                self.nameUser.text = defaults.string(forKey: "usernameKey")
                self.idUser.text = defaults.string(forKey: "IDKey")
                view.addSubview(self.imageProfile)
                view.addSubview(self.buttonLogOut)

            } else {
                print("Error something went fetching info user!")
            }
        }
        
    }
    
    @objc func LogOut() {
        
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: {
                success in 
                DispatchQueue.main.async {
                    if success {
                            // log out success
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: true)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                            // error log out
                        fatalError("Could not log out user")
                        
                    }
                }
            })
            
        }))
        present(actionSheet, animated: true)
    }
}

