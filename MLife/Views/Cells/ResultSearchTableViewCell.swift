//
//  ResultSearchTableViewCell.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 14/08/2022.
//

import UIKit

class ResultSearchTableViewCell: UITableViewCell {
    
    static let identifier = "ResultSearchTableViewCell"
    
    private let songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6.0
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = CGColor.init(red: 242, green: 242, blue: 247, alpha: 1.0)
        return imageView
    }()
    
    private let playImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "play.circle")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let songName: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 17, weight: .bold)
        name.textColor = .label
        name.numberOfLines = 0
        return name
    }()
    
    private let songArtists: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 13, weight: .light)
        name.textColor = .label
        name.numberOfLines = 0
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [songImageView, songName, songArtists, playImage].forEach {
            addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        songImageView.frame = CGRect(x: 3, y: 3, width: 67, height: frame.size.height - 6)
        
        songName.frame = CGRect(x: songImageView.frame.size.width + 15, y: songImageView.frame.origin.x, width: frame.size.width - songImageView.frame.size.width - 55, height: 30)
        songArtists.frame = CGRect(x: songName.frame.origin.x, y: songName.frame.size.height + 5, width: frame.size.width - songImageView.frame.size.width - 55, height: 30)
        
        playImage.frame = CGRect(x: frame.size.width - 40, y: frame.size.height / 2  - 12.5, width: 25, height: 25)
    }
    
    func getDataResultSearch(_ model: Song) {
        songName.text = model.name_song
        songArtists.text = model.artists
        songImageView.sd_setImage(with: model.thumbnail, completed: nil)
    }

}
