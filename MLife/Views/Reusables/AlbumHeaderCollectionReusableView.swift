//
//  AlbumHeaderCollectionReusableView.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 11/08/2022.
//

import UIKit
import SDWebImage

struct AlbumViewModel {
    let name: String
    let artists_name: String
    let thumbnail: URL?
}

final class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "AlbumHeaderCollectionReusableView"
    
    private let imagePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 10).cgPath
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imagePoster)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = frame.size.height / 1.5
        imagePoster.frame = CGRect(x: (frame.size.height - size) / 2, y: 20, width: size, height: size)
        imagePoster.clipsToBounds = true
        imagePoster.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePoster.image = nil
    }
    
    func configure(_ viewModel: AlbumViewModel) {
        imagePoster.sd_setImage(with: viewModel.thumbnail, completed: nil)
    }
    
}
