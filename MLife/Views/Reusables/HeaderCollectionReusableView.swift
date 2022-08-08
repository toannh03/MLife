//
//  HeaderCollectionReusableView.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 09/08/2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel() 
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.sizeToFit()
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.anchor(height: 50, top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 2, paddingRight: 2)
    }
    
    func configure(with titleHeader: String) {
        label.text = titleHeader
    }
        
}
