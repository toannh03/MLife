//
//  ProfileViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .systemBlue
    }
    
}
