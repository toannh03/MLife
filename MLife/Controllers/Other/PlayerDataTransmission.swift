//
//  PlayerDataTransmission.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 10/08/2022.
//

import Foundation
import UIKit
import AVFAudio

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
            guard let url = URL(string: "\(link)") else {
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
    
        self.song = song
        self.songs = []
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        vc.title = song?.name_song
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true, completion: { [weak self] in
            self?.player?.play()
        })
    }
    
}

extension PlayerDataTransmission: PlayerViewControllerDelegate {
    
    func PlayerViewControllerDidTapShuffButton(_ control: PlayerViewController) {
        if songs.isEmpty {
            player?.pause()
        } else {
            
        }
    }
    
    func PlayerViewControllerDidTapPreviousButton(_ control: PlayerViewController) {
        if songs.isEmpty {
            player?.pause()
        } else {
            
        }
    }
    
    func PlayerViewControllerDidTapPlayPauseButton(_ control: PlayerViewController) {
        if control.isPlaying {
            player?.play()
        } else {
            player?.stop()
        }
    }
    
    func PlayerViewControllerDidTapNextButton(_ control: PlayerViewController) {
        print("next song ...")
    }
    
    func PlayerViewControllerDidTapRepeatButton(_ control: PlayerViewController) {
        print("repeart song... ")
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
