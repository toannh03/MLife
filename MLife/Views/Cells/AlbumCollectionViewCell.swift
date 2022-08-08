//
//  AlbumCollectionViewCell.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 08/08/2022.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumCollectionViewCell"

    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textViewTitle: UITextView = {
        let text = UITextView()
        text.sizeToFit()
        text.font = .systemFont(ofSize: 13, weight: .bold)
        text.isScrollEnabled = false
        text.textColor = .label
        return text 
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [albumCoverImageView, textViewTitle].forEach {
            addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumCoverImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 50)
        textViewTitle.frame = CGRect(x: 0, y: albumCoverImageView.frame.size.height, width: frame.size.width, height: 50)
    }
    
    func getDataConfigure(_ model: AlbumResponse) {
        let title = "Album of \(model.name)"
        textViewTitle.text = title
        albumCoverImageView.sd_setImage(with: model.thumbnail, completed: nil)
    }
    
}
