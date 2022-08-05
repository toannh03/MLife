//
//  CustomTextField.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 29/07/2022.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP
    
    func setupTextField(color: UIColor = UIColor.gray) {
        self.leftViewMode = .always
        self.autocorrectionType = .no
        self.layer.masksToBounds = true
        self.textColor = .black
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.backgroundColor = .white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
    }
    
}
