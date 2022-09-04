//
//  PlayerDataTransmission.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 10/08/2022.
//

import Foundation
import UIKit
import AVFAudio
import LNPopupController

final class PlayerDataTransmission {
        
    // Singleton Pattern
    static var shared = PlayerDataTransmission()
    
    private init() {}
    
    var player: AVAudioPlayer?
    
    var vc = PlayerViewController()

    private var song: Song?
    private var songs = [Song]()
    
    private var position: Int = 0
    
    var currentSong: Song? {
        if let song = song, songs.isEmpty {
            return song
        }
        else if !songs.isEmpty {
            return songs[position]
        }
        return nil
    }
        
    func dataTransmission(_ viewController: UIViewController, likeSong: Song?, song: Song?, playlists: [Song]?) {
                
        if let song = song {
            player = nil
            self.song = song
            self.songs = []
            position = 0
        }
        
        if let playlists = playlists {
            player = nil
            self.songs = playlists
            position = 0
        }
                
        guard let link = currentSong?.link else { return }
        streamSong(url: link)
        
        popUpController()
        
        viewController.tabBarController?.popupContentView.popupCloseButtonStyle = .round
        viewController.tabBarController?.popupInteractionStyle = .drag
        viewController.tabBarController?.popupBar.barStyle = .custom
        viewController.tabBarController?.popupBar.progressViewStyle = .top
        viewController.tabBarController?.presentPopupBar(withContentViewController: vc, openPopup:true , animated: false, completion: { [weak self] in
            self?.player?.play() 
            self?.vc.rotateAnimationDisk()
        })
        
        
    }
    
    func streamSong(url: URL) {
        
        guard let url = URL(string: "\(url)") else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            let data = try Data(contentsOf: url)
            
            player = try AVAudioPlayer(data: data)
            
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("Something wrong!")
        }
        
    }
    
    func popUpController() {
                
        vc.dataSource = self
        vc.delegate = self
        
        vc.isPlaying = true
                
        vc.title = currentSong?.name_song
        
        vc.popupItem.title = currentSong?.name_song
        vc.popupItem.subtitle = currentSong?.artists
        if let url = currentSong?.thumbnail {
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async { [ weak self ] in 
                            self?.vc.popupItem.image = image
                        }
                    }
                }
            }
            
        } else {
            vc.popupItem.image = UIImage(named: "IconLauch")
        }
        
        checkPlayPauseInBar()
        
    }
    
    func checkPlayPauseInBar() {
        
        guard let player = player else {
            return
            
        }

        let barButtonPause = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(didTapPlayPauseButtonBar(_:)))
        configureColorButtonBar(barButtonPause)

        let barButtonPlay = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(didTapPlayPauseButtonBar(_:)))
        configureColorButtonBar(barButtonPlay)
        
        let barButtonNext = UIBarButtonItem(image: UIImage(systemName: "forward.fill"), style: .plain, target: self, action: #selector(didTapNextButtonBar))
        configureColorButtonBar(barButtonNext)
        
        vc.popupItem.leadingBarButtonItems = [player.isPlaying ? barButtonPause : barButtonPlay, barButtonNext]
    }
    
    func configureColorButtonBar(_ button: UIBarButtonItem) {
        button.tintColor = UIColor.init(red: 247/255, green: 65/255, blue: 126/255, alpha: 1.0)
    }
    
    @objc func didTapPlayPauseButtonBar(_ button: UIBarButtonItem) {
        
        if vc.isPlaying {
            button.image = UIImage(systemName: "play.fill")
        } else {
            button.image = UIImage(systemName: "pause.fill")
        }
        vc.didTapPlayPauseButton()
        
    }
    
    @objc func didTapNextButtonBar() {
        vc.didTapNextButton()
    }
    
    // Timer delegate method that updates current time display in minutes
    func updateProgress(audioSlider: UISlider) {
        
        guard let player = player else {
            return
        }
        
        let total = Float(player.duration/60) - 0.1
        let current_time = Float(player.currentTime/60)
        
        if total <= current_time {
            vc.didTapNextButton()
        }
        audioSlider.minimumValue = 0.0
        audioSlider.maximumValue = Float(player.duration/60)
        audioSlider.setValue( current_time, animated: true)
        let timeLabel = NSString(format: "%.2f/%.2f", current_time, total) as String
        audioSlider.setThumbImage(progressImage(with: timeLabel), for: .normal)
        
    }
    
    // Create a method that returns thumb image based on UISlider progress
    func progressImage(with progress : String) -> UIImage {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 70, height: 20)
        layer.cornerRadius = 8
        
        let label = UILabel(frame: layer.frame)
        label.text = "\(progress)"
        layer.addSublayer(label.layer)
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func destroyPlayer() {
        
        if player == nil {
            return 
        } else if player!.isPlaying {
            player?.stop()
            player = nil
        }
        
    }
    
}

extension PlayerDataTransmission: PlayerViewControllerDelegate {

    func PlayerViewControllerDidTapShuffButton(_ control: PlayerViewController) {
        
    }
    
    func PlayerViewControllerDidTapPreviousButton(_ control: PlayerViewController) {
        
        if songs.count > 0 {
            if player!.isPlaying || player != nil {
                player!.stop()
                player = nil
            }
            
            if position >= 0 {
                position -= 1
                
                if position < 0 {
                    position = songs.count - 1 
                } else if control.isRepeat == true {
                    
                    if position == 0 {
                        position = songs.count
                    }
                    position += 1
                    
                } else if control.checkRandom == true {
                    let index = Int.random(in: 0 ..< songs.count)
                    if index == position {
                        position = index - 1
                    }
                    position = index
                }
                
                guard let link = currentSong?.link else { return }
                streamSong(url: link)
                player?.prepareToPlay()
                player?.play()
                control.isPlaying = true
                control.checkControl()
                popUpController()
                
            }
        }
    }
    
    func PlayerViewControllerDidTapPlayPauseButton(_ control: PlayerViewController) {
        if let player = player {
            if player.isPlaying {
                player.pause()
                checkPlayPauseInBar()
                control.isPlaying = false
            } else {
                player.play()
                checkPlayPauseInBar()
                control.isPlaying = true
            }
        }
        
    }
    
    func PlayerViewControllerDidTapNextButton(_ control: PlayerViewController) {
        
        if songs.count > 0 {
            if player!.isPlaying || player != nil {
                player!.stop()
                player = nil
            }
            if (position < songs.count) {
                
                position += 1
                
                if (position > (songs.count - 1)) {
                    position = 0
                } else if control.isRepeat == true {
                    if position == 0 {
                        position = songs.count
                    }
                    position -= 1
                } else if control.checkRandom == true {
                    let index = Int.random(in: 0 ..< songs.count)
                    if index == position {
                        position = index - 1
                    }
                    position = index
                }
                                
                guard let link = currentSong?.link else { return }
                streamSong(url: link)
                player?.prepareToPlay()
                player?.play()
                control.isPlaying = true
                control.checkControl()
                popUpController()
            }
        }
    }
    
    func PlayerViewControllerDidTapRepeatButton(_ control: PlayerViewController) {
        
    }
    
    func PlayerControlSlider(_ control: PlayerViewController, didSelectSlider value: Float) {
        if let player = player {
            if player.isPlaying {
                player.stop()
                player.currentTime = TimeInterval(value*60) 
                player.prepareToPlay()
                player.play()
            } else {
                player.stop()
                player.currentTime = TimeInterval(value*60) 
                player.prepareToPlay()
            }
            
        }
    }
    
}

extension PlayerDataTransmission: TransmissionDataSource {
    
    var name_song: String? {
        return currentSong?.name_song
    }
    
    var link_song: URL? {
        return currentSong?.link
    }
    
    var URL_image: URL? {
        return currentSong?.thumbnail
    }
    
    var description: String? {
        return currentSong?.artists
    }
    
}
