//
//  PlayerViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 10/08/2022.
//

import UIKit
import SDWebImage
import AVFoundation

class PlayerViewController: UIViewController {
    
    weak var dataSource: TransmissionDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    var timerProgress : Timer?
    
    var vol = AVAudioSession.sharedInstance().outputVolume


    public var isPlaying = true
    public var isRepeat = false;
    public var checkRandom = false;

    // MARK: - Cover image
    private let colorCoverView = UIView()
    private let disk = UIView()
    
    private let playCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.6
        imageView.layer.borderColor = CGColor(red: 209, green: 209, blue: 214, alpha: 1.0)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Controls 
    private let controlsPlayer = UIView()
    private var stack = UIStackView()
    
    lazy var sliderSong: UISlider = {
        let slider = UISlider()
        slider.isContinuous = true
        slider.tintColor = .black
        slider.addTarget(self, action: #selector(didTapSelectSlider(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var volumeSong: UISlider = {
        let volume = UISlider()
        volume.tintColor = .black
        volume.minimumValue = vol
        volume.maximumValue = vol + 10.0
        volume.addTarget(self, action: #selector(didTapSelectVolumeSlider(_:)), for: .valueChanged)
        return volume
    }()
    
    private let nameSong: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "___"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let descriptionSong: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "___"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let shuffleButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "shuffle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        return button
    }()
    
    fileprivate let previousButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)), for: .normal)
        return button
    }()
    
    fileprivate let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .light, scale: .small)), for: .normal)
        return button
    }()
    
    fileprivate let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)), for: .normal)
        return button
    }()
    
    fileprivate let repeatButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "repeat", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light)), for: .normal)
        return button
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {   
        super.viewDidLoad()
                        
        colorCoverView.frame = view.bounds
        
        view.addSubview(colorCoverView)
        
        view.addSubview(disk)
        
        disk.addSubview(playCoverImage)
        
        view.addSubview(controlsPlayer)
                
        [nameSong, descriptionSong, sliderSong, volumeSong].forEach {
            controlsPlayer.addSubview($0)
        }

        configureStackControl()
                
        configureControlPlayer()
        
        let thumbImage = UIImage(systemName: "speaker.wave.2.fill")!
        volumeSong.setThumbImage( thumbImage, for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Configure data when next song of click one song 
                
        configureGetData()
                
        startTimer()
        
        checkControl()
                
    }
    
    // Configure timer for slider progress
    func startTimer() {
        
        stopTimer()
        guard timerProgress == nil else { return }
        timerProgress = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(progressTimer), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer() {
        
        guard timerProgress != nil else { return }
        timerProgress?.invalidate()
        timerProgress = nil
        
    }
    
    @objc func progressTimer() {
        PlayerDataTransmission.shared.updateProgress(audioSlider: sliderSong)
    }
    
    // MARK: - Create layout
    override func viewDidLayoutSubviews() {
  
        colorCoverView.addGradientWithColor(color: .random)

        let sizeDisk: CGFloat = 300
        disk.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width + view.safeAreaInsets.top)
        playCoverImage.frame = CGRect(x: disk.frame.size.width / 2 - (sizeDisk/2), y: disk.frame.size.height / 2 - (sizeDisk/2.5) , width: sizeDisk, height: sizeDisk)
        playCoverImage.layer.cornerRadius = playCoverImage.frame.size.width / 2

        let heightImage = disk.frame.size.height + view.safeAreaInsets.top
        
        
        // Configure control button
        controlsPlayer.frame = CGRect(x: 10, y: heightImage, width: view.frame.size.width - 20, height: view.frame.size.height - heightImage - view.safeAreaInsets.top - 10)
        controlsPlayer.layer.cornerRadius = 20.0
        controlsPlayer.backgroundColor = .secondarySystemFill
        
        let padding: CGFloat = 20
        nameSong.frame = CGRect(x: padding, y: 30, width:  controlsPlayer.frame.size.width - 40, height: 25)
        descriptionSong.frame = CGRect(x: padding, y: nameSong.frame.size.height + 40, width:  controlsPlayer.frame.size.width - 40, height: 25)
        
        sliderSong.frame = CGRect(x: padding, y: descriptionSong.frame.size.height + 60, width: controlsPlayer.frame.size.width - 40, height: 40)
        
        stack.frame = CGRect(x: padding, y: sliderSong.frame.size.height + 80, width: controlsPlayer.frame.size.width - 40, height: 80)
        
        volumeSong.frame = CGRect(x: padding + 10, y: stack.frame.size.height + 120, width: controlsPlayer.frame.size.width - 60, height: 40)
        
    }
    
    func rotateAnimationDisk() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.playCoverImage.rotate()
        }
        
    }
    
    func configureStackControl() {
        
        stack = UIStackView(arrangedSubviews: [shuffleButton ,previousButton , playPauseButton ,nextButton, repeatButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        controlsPlayer.addSubview(stack)
        
    }
    
    // MARK: - Configure 
    
    func configureGetData() {
        
        playCoverImage.sd_setImage(with: dataSource?.URL_image, completed: nil)
        nameSong.text = dataSource?.name_song
        descriptionSong.text = dataSource?.description
            
    }
    
    func checkControl() {
                
        let pause = UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .light, scale: .small))
        let play = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .light, scale: .small))
                
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
                        
        self.isPlaying ? playCoverImage.resumeAnimation() : playCoverImage.pauseAnimation()
        self.isPlaying ? startTimer() : stopTimer()
        
    }
    
    func configureControlPlayer() {
        
        shuffleButton.addTarget(self, action: #selector(didTapShuffButton), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(didTapRepeatButton), for: .touchUpInside)
        
    }
    
}

// MARK: - Control play song

extension PlayerViewController {
    
    @objc func didTapShuffButton() {
        
        delegate?.PlayerViewControllerDidTapShuffButton(self)
        
        if checkRandom == false {
            if isRepeat == true {
                isRepeat = false;
                shuffleButton.tintColor = .systemGreen
                repeatButton.tintColor = .black
            }
            shuffleButton.tintColor = .systemGreen
            checkRandom = true;
        } else {
            checkRandom = false;
            shuffleButton.tintColor = .black
        }
        
    }
    
    @objc func didTapPreviousButton() {

        delegate?.PlayerViewControllerDidTapPreviousButton(self)
        
        playPauseButton.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .light, scale: .small)), for: .normal)
        configureGetData()
        
    }
    
    @objc func didTapPlayPauseButton() {
        
        delegate?.PlayerViewControllerDidTapPlayPauseButton(self)
        
        checkControl()
    }
    
    @objc func didTapNextButton() {
        
        delegate?.PlayerViewControllerDidTapNextButton(self)
        
        playPauseButton.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .light, scale: .small)), for: .normal)
        
        configureGetData()
    }
    
    @objc func didTapRepeatButton() {
        
        delegate?.PlayerViewControllerDidTapRepeatButton(self)
        
        if isRepeat == false {
            if checkRandom == true {
                checkRandom = false;
                repeatButton.tintColor = .systemGreen
                shuffleButton.tintColor = .black
            }
            isRepeat = true;
            repeatButton.tintColor = .systemGreen
        } else {
            isRepeat = false;
            repeatButton.tintColor = .black
        }
        
    }
    
    @objc func didTapSelectSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.PlayerControlSlider(self, didSelectSlider: value)
    }
    
    @objc func didTapSelectVolumeSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.PlayerControlVolumeSlider(self, didSelectSlider: value)
    }
    
}
