//
//  AlbumDetailViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 11/08/2022.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    private let album: AlbumResponse
    
    private let imageCoverNotSong: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "emptyNotification")
        imageView.isHidden = true
        return imageView
    }()
        
    init(album: AlbumResponse) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            return HomeViewController.createBasicCompositionLayout(widthItem: .fractionalWidth(1.0), heightItem: .absolute(70), top: 3, leading: 0, bottom: 3, trailing: 0, widthVertical: .fractionalWidth(1.0), heightVertical: .absolute(70), scrollBehavior: .continuous, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(400))!
        }))
        collection.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        collection.register(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier)
        return collection
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
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

extension AlbumDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        
        if album.songs.isEmpty {
            imageCoverNotSong.isHidden = false
            cell.isHidden = true
        } else {
            let song = album.songs[indexPath.row]       
            cell.getDataConfigure(song)
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier, for: indexPath) as? AlbumHeaderCollectionReusableView , 
            kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerViewMode = AlbumViewModel(name: album.name, artists_name: album.artists_name, thumbnail: album.thumbnail)
        header.configure(headerViewMode)
        return header
    }
    
}
