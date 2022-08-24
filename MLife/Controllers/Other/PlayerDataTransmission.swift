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
    
    private var song: Song?
    private var songs = [Song]()
    
    var currentSong: Song? {
        if let song = song, songs.isEmpty {
            return song
        }
        else if !songs.isEmpty {
            return songs.first
        }
        return nil
    }
    
    var player: AVAudioPlayer?
    
    func dataTransmission(_ viewController: UIViewController, likeSong: Song?, song: Song?, playlists: [Song]?) {
        if let link = song?.link {
            streamSong(url: link)
        }
        
        self.song = song
        self.songs = []
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        vc.title = song?.name_song
        
        vc.popupItem.title = song?.name_song
        vc.popupItem.subtitle = song?.artists
        
        if let url = song?.thumbnail {
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            vc.popupItem.image = image
                        }
                    }
                }
            }
            
        } else {
            vc.popupItem.image = UIImage(named: "IconLauch")
        }
                
        viewController.tabBarController?.presentPopupBar(withContentViewController: vc, openPopup:true , animated: false, completion: { [weak self] in
            self?.player?.play() 
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
                        
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("Something wrong!")
        }
        
    }
    
    // Timer delegate method that updates current time display in minutes
    func updateProgress(audioSlider: UISlider) {
        let total = Float(player!.duration/60)
        let current_time = Float(player!.currentTime/60)
        audioSlider.minimumValue = 0.00
        audioSlider.maximumValue = Float(player!.duration/60)
        audioSlider.setValue(Float(player!.currentTime/60), animated: true)
        let timeLabel = NSString(format: "%.2f/%.2f", current_time, total) as String
        audioSlider.setThumbImage(progressImage(with: timeLabel), for: .normal)
    }
    
    // Create a method that returns thumb image based on UISlider progress
    func progressImage(with progress : String) -> UIImage {
        let layer = CALayer()
        layer.backgroundColor = UIColor.systemGreen.cgColor
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
    
}

extension PlayerDataTransmission: PlayerViewControllerDelegate {

    func PlayerViewControllerDidTapShuffButton(_ control: PlayerViewController) {
    }
    
    func PlayerViewControllerDidTapPreviousButton(_ control: PlayerViewController) {
        if songs.isEmpty {
            player?.pause()
        } else {
            
        }
    }
    
    func PlayerViewControllerDidTapPlayPauseButton(_ control: PlayerViewController) {
        if let player = player {
            if player.isPlaying {
                player.pause()
                control.isPlaying = false
            } else {
                player.play()
                control.isPlaying = true
            }
        }
    }
    
    func PlayerViewControllerDidTapNextButton(_ control: PlayerViewController) {
        if songs.count > 0 {
            if player!.isPlaying || player != nil {
                player!.stop()
                
            }
        }
    }
    
    func PlayerViewControllerDidTapRepeatButton(_ control: PlayerViewController) {
        
    }
    
    func PlayerControlSlider(_ control: PlayerViewController, didSelectSlider value: Float) {
        player!.currentTime = TimeInterval(value)
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
