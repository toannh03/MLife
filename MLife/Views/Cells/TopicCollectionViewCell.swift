//
//  TopicCollectionViewCell.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 08/08/2022.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopicCollectionViewCell"
    
    private let topicCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "testImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()
    
    private let topicTitle: UILabel = {
        let name = UILabel()
        name.textAlignment = .center
        name.font = .systemFont(ofSize: 11, weight: .bold)
        name.textColor = .white
        name.numberOfLines = 0
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(topicCoverImageView)
        
        topicCoverImageView.addSubview(topicTitle)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topicCoverImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0.5, paddingBottom: 0.5, paddingLeft: 0.5, paddingRight: 0.5)
        
        topicTitle.anchor(top: topicCoverImageView.topAnchor, bottom: topicCoverImageView.bottomAnchor, left: topicCoverImageView.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topicTitle.text = nil
        topicCoverImageView.image = nil
    }
    
    func configure(with model: TopicResponse) {
        let nameTitle = model.name.uppercased()
        topicTitle.text = nameTitle
        topicCoverImageView.sd_setImage(with: model.image, completed: nil)
    }
    
    
}
