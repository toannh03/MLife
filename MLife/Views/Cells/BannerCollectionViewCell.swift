//
//  HeaderCollectionViewCell.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 01/07/2022.
//

import UIKit
import Gemini
import SDWebImage

class BannerCollectionViewCell: GeminiCell {
    
    static let identifier = "BannerCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
    }
    
    func getDataConfigure(image: URL?) {
        imageView.sd_setImage(with: image, completed: nil)
    }
    
}
