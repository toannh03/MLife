//
//  MostLikeSongCollectionViewCell.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 09/08/2022.
//

import UIKit

class MostLikeSongCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MostLikeSongCollectionViewCell"
    
    private let songCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()
    
    private let songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = CGColor.init(red: 242, green: 242, blue: 247, alpha: 1.0)
        return imageView
    }()
    
    private let playImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "play.circle")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let songName: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 14, weight: .bold)
        name.textColor = .white
        name.numberOfLines = 0
        return name
    }()
    
    private let songArtists: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 12, weight: .heavy)
        name.textColor = .white
        name.numberOfLines = 0
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(songCoverImageView)
        [songImageView, songName, songArtists, playImage].forEach {
            songCoverImageView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        songCoverImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        songImageView.frame = CGRect(x: 10, y: 10, width: 70, height: songCoverImageView.bounds.size.height - 20)
        songImageView.layer.cornerRadius = songImageView.bounds.size.width / 2
        
        songName.frame = CGRect(x: songImageView.frame.size.width + 15, y: songImageView.frame.origin.x + 5, width: songCoverImageView.bounds.size.width - songImageView.frame.size.width - 55, height: 30)
        songArtists.frame = CGRect(x: songName.frame.origin.x, y: songName.frame.size.height + 10, width: frame.size.width - songImageView.frame.size.width - 55, height: 30)
        
        playImage.frame = CGRect(x: songCoverImageView.bounds.size.width - 40, y: songCoverImageView.bounds.size.height / 2  - 12.5, width: 25, height: 25)
    }
    
    func getDataConfigure(_ model: Song) {
        songName.text = model.name_song
        songArtists.text = model.artists
        songCoverImageView.sd_setImage(with: model.thumbnail, completed: nil)
        songImageView.sd_setImage(with: model.thumbnail, completed: nil)
    }
}


/*
 
 songImageView.frame = CGRect(x: 10, y: 10, width: 70, height: frame.size.height - 20)
 songImageView.layer.cornerRadius = songImageView.bounds.size.width / 2
 songName.frame = CGRect(x: songImageView.frame.size.width + 15, y: songImageView.frame.origin.x + 5, width: frame.size.width - songImageView.frame.size.width - 50, height: 30)
 songArtists.frame = CGRect(x: songName.frame.origin.x, y: songName.frame.size.height + 10, width: frame.size.width - songImageView.frame.size.width - 50, height: 30)
 
 */
