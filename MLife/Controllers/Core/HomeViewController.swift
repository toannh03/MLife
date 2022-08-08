//
//  HomeViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit

enum HomeSectionType {
    case Topic(model: [TopicResponse])
}

class HomeViewController: UIViewController {
    
    var trending = [TredingResponse]()
    
    private var topics: [TopicResponse] = []
    
    private var sections = [HomeSectionType]()

    private let collectionView: UICollectionView = {
        
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return createBasicListLayout(section: sectionNumber)
        }
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collection.register(BannerCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerCollectionReusableView.identifier)
        collection.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        
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
    
//        APIClient.shared.getTopics { status in
//            switch status {
//                case .success(let model):
//                    print(model)
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    break
//            }
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func configureNavigationBar() {
        
        let settingImage = UIImage(systemName: "gear")
        let notificationImage = UIImage(systemName: "bell.badge.fill")
        let searchImage = UIImage(systemName: "magnifyingglass")
        
        let settingButton   = UIBarButtonItem(image: settingImage,  style: .plain, target: self, action: #selector(didTapEditButton(sender:)))
        let notificationButton = UIBarButtonItem(image: notificationImage,  style: .plain, target: self, action: #selector(didTapNotificationButton(sender:)))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))
        
        navigationItem.rightBarButtonItems = [notificationButton, settingButton, searchButton]
    }
    
    @objc func didTapEditButton(sender: AnyObject){
        
    }
    
    @objc func didTapNotificationButton(sender: AnyObject){
        
    }
    
    @objc func didTapSearchButton(sender: AnyObject){
        
    }
    
    func fetchData() {
        let group = DispatchGroup()
            
        // The enter() method tells the dispatch group that a task has already been started
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
            APIClient.shared.getTopics() { result in 
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
        
        group.notify(queue: .main) { 
            self.sections.append(.Topic(model: self.topics))
            self.collectionView.reloadData()
        }
    }
    
}

extension HomeViewController {
    
    static func createBasicListLayout(section: Int) -> NSCollectionLayoutSection { 
        
        switch section {
                
            case 0:
                
                return createNestedGround( widthItem: .fractionalWidth(1.0), heightItem: .absolute(90),top: 4, leading:4, bottom: 4,trailing: 4, widthVertical: .fractionalWidth(1.0), heightVertical: .absolute(188), widthHorizotal: .fractionalWidth(1.0), heightHorizotal: .absolute(188), countVertical: 2, countHorizotal: 2, headerWidth: .fractionalWidth(1.0), headerHeight: .absolute(260))!
                
            case 1:
                
                return createBasicCompositionLayout(widthItem: .absolute(215), heightItem: .absolute(200), top: 5, leading: 15, bottom: 5, trailing: 0, widthHorizotal: .absolute(215), heightHorizotal: .absolute(200), scrollBehavior: .continuous)!
                
            case 2: 
                
                return createBasicCompositionLayout(widthItem: .absolute(215), heightItem: .absolute(200), top: 5, leading: 15, bottom: 5, trailing: 0, widthHorizotal: .absolute(215), heightHorizotal: .absolute(200), scrollBehavior: .continuous)!
                
            case 3: 
                
                return createBasicCompositionLayout(widthItem: .absolute(215), heightItem: .absolute(200), top: 5, leading: 15, bottom: 5, trailing: 0, widthHorizotal: .absolute(215), heightHorizotal: .absolute(200), scrollBehavior: .continuous)!
            case 4: 
                return createBasicCompositionLayout(widthItem: .fractionalWidth(1.0), heightItem: .absolute(100), top: 5, leading: 15, bottom: 5, trailing: 15, widthVertical: .fractionalWidth(1.0), heightVertical: .absolute(100), scrollBehavior: .continuous)!
                
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
            case .Topic(let model):
                return model.count
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
            default:
                return UICollectionViewCell()
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerCollectionReusableView.identifier, for: indexPath) as! BannerCollectionReusableView
        header.configure(with: trending)
        return header
        
    }

    
}

