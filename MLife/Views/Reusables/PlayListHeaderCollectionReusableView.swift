//
//  PlayListCollectionReusableView.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 12/08/2022.
//

import UIKit

struct PlayListViewModel {
    let name: String
    let description: String
    let thumbnail: URL?
}

protocol PlayListHeaderCollectionReusableViewDelegate: AnyObject {
    func playListAllSong(_ headerSong: PlayListHeaderCollectionReusableView)  
}

class PlayListHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "PlayListHeaderCollectionReusableView"
        
    weak var delegate: PlayListHeaderCollectionReusableViewDelegate?
    
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
    
    private let nameAlbum: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.sizeToFit()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let artistsAlbum: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.sizeToFit()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let playAllSongButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemMint
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imagePoster)
        addSubview(nameAlbum)
        addSubview(artistsAlbum)
        addSubview(playAllSongButton)
        playAllSongButton.addTarget(self, action: #selector(didTapPlayAllButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = frame.size.width / 1.5
        imagePoster.frame = CGRect(x: (frame.size.width - size) / 2, y: 20, width: size, height: size)
        imagePoster.clipsToBounds = true
        imagePoster.layer.cornerRadius = 10
        nameAlbum.frame = CGRect(x: 0, y: imagePoster.frame.size.height + 23, width: frame.size.width, height: 30)
        artistsAlbum.frame = CGRect(x: 0, y: nameAlbum.frame.origin.y + nameAlbum.frame.size.height, width: frame.size.width, height: 20)
        
        playAllSongButton.frame = CGRect(x: (frame.size.width - 100) / 2 , y: artistsAlbum.frame.origin.y + artistsAlbum.frame.size.height + 10, width: 100, height: 50)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePoster.image = nil
    }
    
    func configure(_ viewModel: PlayListViewModel) {
        imagePoster.sd_setImage(with: viewModel.thumbnail, completed: nil)
        nameAlbum.text = viewModel.name
        artistsAlbum.text = viewModel.description
    }
    
    @objc func didTapPlayAllButton() {
        delegate?.playListAllSong(self)
    }
}
