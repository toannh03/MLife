//
//  PlayListDetailViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 11/08/2022.
//

import UIKit

class PlayListDetailViewController: UIViewController {

    private let playlist: PlayListResponse
    
    private let imageCoverNotSong: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "emptyNotification")
        imageView.isHidden = true
        return imageView
    }()
    
    init(playlist: PlayListResponse) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            return HomeViewController.createBasicCompositionLayout(widthItem: .fractionalWidth(1.0), heightItem: .absolute(70), top: 3, leading: 0, bottom: 3, trailing: 0, widthVertical: .fractionalWidth(1.0), heightVertical: .absolute(70), scrollBehavior: .continuous, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(450))!
        }))
        collection.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        collection.register(PlayListHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier)
        return collection
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(imageCoverNotSong)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        imageCoverNotSong.centerX(with: self.view)
        imageCoverNotSong.centerY(withView: self.view)
        imageCoverNotSong.setWidth(width: 150)
        imageCoverNotSong.setHeight(height: 150)
    }
}

extension PlayListDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlist.songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        
        if playlist.songs.isEmpty {
            imageCoverNotSong.isHidden = false
            cell.isHidden = true
        } else {
            let song = playlist.songs[indexPath.row]       
            cell.getDataConfigure(song)
            cell.backgroundColor = .secondarySystemBackground
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.red
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier, for: indexPath) as? PlayListHeaderCollectionReusableView , 
                kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerViewMode = PlayListViewModel(name: playlist.name, description: "Release Date : \(String.formatedDate(string: playlist.createdAt))", thumbnail: playlist.thumbnail)
        header.configure(headerViewMode)
        return header
    }
    
}
