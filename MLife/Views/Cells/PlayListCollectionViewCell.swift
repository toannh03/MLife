//
//  PlayListCollectionViewCell.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 09/08/2022.
//

import UIKit

class PlayListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayListCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
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
        [playlistCoverImageView, textViewTitle].forEach {
            addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        playlistCoverImageView.image = nil
        textViewTitle.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistCoverImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 50)
        textViewTitle.frame = CGRect(x: 0, y: playlistCoverImageView.frame.size.height, width: frame.size.width, height: 50)
    }
    
    func getDataConfigure(_ model: PlayListResponse) {
        textViewTitle.text = model.name
        playlistCoverImageView.sd_setImage(with: model.image, completed: nil)
    }
    
}
