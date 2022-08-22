//
//  Protocols.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 15/08/2022.
//

import Foundation

public protocol TransmissionDataSource: AnyObject {
    var name_song: String? { get }
    var link_song: URL? { get }
    var URL_image: URL? { get }
    var description: String? { get }
}

protocol PlayerViewControllerDelegate: AnyObject {
    func PlayerViewControllerDidTapShuffButton(_ control: PlayerViewController)
    func PlayerViewControllerDidTapPreviousButton(_ control: PlayerViewController)
    func PlayerViewControllerDidTapPlayPauseButton(_ control: PlayerViewController)
    func PlayerViewControllerDidTapNextButton(_ control: PlayerViewController)
    func PlayerViewControllerDidTapRepeatButton(_ control: PlayerViewController)
}
