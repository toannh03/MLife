//
//  PlayerDataTransmission.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 10/08/2022.
//

import Foundation
import UIKit

class PlayerDataTransmission {
    
    static func dataTransmission(_ viewController: UIViewController, likeSong: Song?, playlist: Song?, playlists: [Song]?) {
        let vc = PlayerViewController()
        viewController.present(vc, animated: true)
    }
}
