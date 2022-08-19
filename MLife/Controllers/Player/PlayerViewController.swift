//
//  PlayerViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 10/08/2022.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // MARK: - Cover image
    private let playCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemRed
        return imageView
    }()
    
    // MARK: - Controls 
    private let controlsPlayer = UIView()
    private var stack = UIStackView()
    
    private let volumeSlider: UISlider = {
        let volume = UISlider()
        volume.value = 0.5
        return volume
    }()
    
    private let nameSong: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Some song in here ...."
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let descriptionSong: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Description of song ..."
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let shuffleButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "shuffle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)), for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 70, weight: .light, scale: .small)), for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)), for: .normal)
        return button
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "repeat", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(playCoverImage)
        
        view.addSubview(controlsPlayer)
        controlsPlayer.addSubview(nameSong)
        controlsPlayer.addSubview(descriptionSong)
        controlsPlayer.addSubview(volumeSlider)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        configureStackControl()

    }
    
    override func viewDidLayoutSubviews() {
        playCoverImage.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        let heightImage = playCoverImage.frame.size.height
        controlsPlayer.frame = CGRect(x: 10, y: heightImage + 10, width: view.frame.size.width - 20, height: view.frame.size.height - heightImage - view.safeAreaInsets.top)
        
        nameSong.frame = CGRect(x: 20, y: 10, width:  controlsPlayer.frame.size.width - 40, height: 25)
        descriptionSong.frame = CGRect(x: 20, y: nameSong.frame.size.height + 10, width:  controlsPlayer.frame.size.width - 40, height: 25)
        
        volumeSlider.frame = CGRect(x: 20, y: descriptionSong.frame.size.height + 40, width: controlsPlayer.frame.size.width - 40, height: 40)
        stack.frame = CGRect(x: 20, y: volumeSlider.frame.size.height + 60, width: controlsPlayer.frame.size.width - 40, height: 80)
    }
    
    func configureStackControl() {
        stack = UIStackView(arrangedSubviews: [shuffleButton ,previousButton , playPauseButton ,nextButton, repeatButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        controlsPlayer.addSubview(stack)
    }
    
    @objc func didTapClose() {
        print("close")
    }
    
}
