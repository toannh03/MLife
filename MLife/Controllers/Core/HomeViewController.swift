//
//  HomeViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit

enum HomeSectionType {
    case Topic(model: [TopicResponse])
    case Album(model: [AlbumResponse])
    case PlayList(model: [PlayListResponse])
    case MostLikeSong(model: [Song]) 
}

class HomeViewController: UIViewController {
    
    private var trending: [TredingResponse] = []
    private var topics: [TopicResponse] = []
    private var albums: [AlbumResponse] = []
    private var playlists: [PlayListResponse] = []
    private var likesongs: [Song] = []
    
    private var titleHeader: [String] = ["","Today's Like", "New Relase", "Songs"]
    private var sections = [HomeSectionType]()

    private let collectionView: UICollectionView = {
        
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return createBasicListLayout(section: sectionNumber)
        }
        let collection = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collection.register(BannerCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerCollectionReusableView.identifier)
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
   
        collection.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        collection.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collection.register(PlayListCollectionViewCell.self, forCellWithReuseIdentifier: PlayListCollectionViewCell.identifier)
        collection.register(MostLikeSongCollectionViewCell.self, forCellWithReuseIdentifier: MostLikeSongCollectionViewCell.identifier)

        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar() 
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func configureNavigationBar() {
        
        let settingImage = UIImage(systemName: "gear")
        let notificationImage = UIImage(systemName: "bell.badge.fill")
        let searchImage = UIImage(systemName: "magnifyingglass")
        
        let settingButton   = UIBarButtonItem(image: settingImage,  style: .plain, target: self, action: #selector(didTapSettingButton(sender:)))
        let notificationButton = UIBarButtonItem(image: notificationImage,  style: .plain, target: self, action: #selector(didTapNotificationButton(sender:)))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))
        
        navigationItem.rightBarButtonItems = [notificationButton, settingButton, searchButton]
    }
    
    @objc func didTapSettingButton(sender: AnyObject){
        let vc = SettingViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapNotificationButton(sender: AnyObject){
        let vc = NotificationViewController()
        vc.title = "Notification"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapSearchButton(sender: AnyObject){
        
    }
    
    func fetchData() {
        
        let group = DispatchGroup()
            
        // The enter() method tells the dispatch group that a task has already been started
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
            
        APIClient.shared.getSongInTrending { status in
            defer {
                group.leave()
            }
            switch status {
                case .success(let model):
                    self.trending = model
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.reloadData()
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
            // Topics
            APIClient.shared.getTopics { result in 
                defer {
                    group.leave()
                }
                switch result {
                    case .success(let model):
                        self.topics = model
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        APIClient.shared.getSongInAlbum { result in
            defer {
                group.leave()
            }
            switch result {
                case .success(let model):
                    self.albums = model
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        APIClient.shared.getSongInPlayList { result in
            defer {
                group.leave()
            }
            switch result {
                case .success(let model):
                    self.playlists = model
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        APIClient.shared.getMostLikeSong { result in
            defer {
                group.leave()
            }
            switch result {
                case .success(let model):
                    self.likesongs = model
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.configureDataResponse(topics: self!.topics, albums: self!.albums, playlists: self!.playlists, likesongs: self!.likesongs)
        }
    }
    
    private func configureDataResponse(topics: [TopicResponse], albums: [AlbumResponse], playlists: [PlayListResponse], likesongs: [Song]) {
        
        self.topics = topics
        self.albums = albums
        self.playlists = playlists
        self.likesongs = likesongs
        
        sections.append(.Topic(model: topics))
        sections.append(.Album(model: albums))
        sections.append(.PlayList(model: playlists))
        sections.append(.MostLikeSong(model: likesongs))
        collectionView.reloadData()
    }
}

extension HomeViewController {
    
    static func createBasicListLayout(section: Int) -> NSCollectionLayoutSection { 
        
        switch section {
                
            case 0:
                
                return createNestedGround( widthItem: .fractionalWidth(1.0), heightItem: .absolute(90),top: 0, leading:4, bottom: 4,trailing: 4, widthVertical: .fractionalWidth(1.0), heightVertical: .absolute(188), widthHorizotal: .fractionalWidth(1.0), heightHorizotal: .absolute(188), countVertical: 2, countHorizotal: 2, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(260))!
                
            case 1:
                
                return createBasicCompositionLayout(widthItem: .absolute(165), heightItem: .absolute(200), top: 5, leading: 7.5, bottom: 0, trailing: 7.5, widthHorizotal: .absolute(165), heightHorizotal: .absolute(200), scrollBehavior: .continuous, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(40))!
                
            case 2: 
                
                return createBasicCompositionLayout(widthItem: .absolute(165), heightItem: .absolute(200), top: 5, leading: 7.5, bottom: 0, trailing: 7.5, widthHorizotal: .absolute(165), heightHorizotal: .absolute(200), scrollBehavior: .continuous, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(40))!
                
            case 3: 
                
                return createBasicCompositionLayout(widthItem: .fractionalWidth(1.0), heightItem: .absolute(100), top: 5, leading: 7.5, bottom: 5, trailing: 7.5, widthVertical: .fractionalWidth(1.0), heightVertical: .absolute(100), scrollBehavior: .continuous, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(40))!
                
            default:
                
                return createNestedGround(widthItem: .fractionalWidth(1.0), heightItem: .fractionalHeight(1.0), top: 5, leading: 15, bottom: 5, trailing: 15, widthVertical: .fractionalWidth(1.0), heightVertical: .fractionalHeight(1.0), widthHorizotal: .absolute(220), heightHorizotal: .absolute(300), countVertical: 3, countHorizotal: 1)!
                
        }
    }
    
}

// MARK: - DELEGATE && DATASOURCE

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            case .Topic(let topic):
                return topic.count
            case .Album(let album):
                return album.count
            case .PlayList(let playlist):
                return playlist.count
            case .MostLikeSong(let like):
                return like.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let types = sections[indexPath.section]
        
        switch types {
            case .Topic(let model):

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as? TopicCollectionViewCell else { return UICollectionViewCell() }
                let viewModel = model[indexPath.row] 
                cell.layer.cornerRadius = 8.0
                cell.configure(with: viewModel)                
                return cell
                
            case .Album(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
                let viewModel = model[indexPath.row] 
                cell.getDataConfigure(viewModel)    
                return cell
            case .PlayList(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListCollectionViewCell.identifier, for: indexPath) as? PlayListCollectionViewCell else { return UICollectionViewCell() }
                let viewModel = model[indexPath.row] 
                cell.layer.cornerRadius = 8.0
                cell.getDataConfigure(viewModel)    
                return cell
            case .MostLikeSong(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostLikeSongCollectionViewCell.identifier, for: indexPath) as? MostLikeSongCollectionViewCell else { return UICollectionViewCell() }
                let viewModel = model[indexPath.row]
                cell.backgroundColor = .systemRed
                cell.getDataConfigure(viewModel)    
                cell.layer.cornerRadius = 8.0
//                cell.getDataConfigure(viewModel)    
                return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        
        switch section {
            case .Topic:
                let category = topics[indexPath.row]
                let vc = CategoryViewController(category: category)
                vc.title = category.name
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
                break
            case .Album:
                let album = albums[indexPath.row]
                let vc = AlbumDetailViewController(album: album)
                vc.title = album.name
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
                break
            case .PlayList:
                break
            case .MostLikeSong:
                break
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        switch section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerCollectionReusableView.identifier, for: indexPath) as! BannerCollectionReusableView
                header.configure(with: trending)
                return header             
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
                header.configure(with: titleHeader[indexPath.section])
                return header 
            case 2:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
                header.configure(with: titleHeader[indexPath.section])
                return header 
            case 3: 
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
                header.configure(with: titleHeader[indexPath.section])
                return header 
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
                    //                header.configure(with: trending)
                return header 
        }
    }

}

