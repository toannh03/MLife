//
//  BannerCollectionView.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 01/07/2022.
//

import UIKit
import Gemini

class BannerCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "BannerCollectionReusableView"
    
    var trending = [TredingResponse]()

    var timer: Timer? // A timer that fires after a certain time interval has elapsed
    var currentPage: Int = 0 
            
    // Collection view for banner 
    lazy var collectionView: GeminiCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectiton = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        collectiton.translatesAutoresizingMaskIntoConstraints = false 
        collectiton.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        collectiton.showsHorizontalScrollIndicator = false
        return collectiton 
        }()
    
    fileprivate let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .darkGray
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pageControl.numberOfPages = trending.count
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(pageControl)
        
        // Create animation switch page
        collectionView.gemini
            .cubeAnimation()
            .cubeDegree(90)

        startTimer()
    }
    
    func configure(with model: [TredingResponse]) {
        self.trending = model
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        //Add constraint
        collectionView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingBottom: 15, paddingLeft: 15, paddingRight: 15)
        
        pageControl.frame = CGRect(x: 0, y: frame.size.height - 56, width: frame.size.width, height: 30)
    }
    
    // MARK: - Make transition loop with PageControl
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollNextToIndex), userInfo: nil, repeats: true)
    }
    
    @objc func scrollNextToIndex() {
        
        if currentPage < trending.count - 1 {
            currentPage += 1
        } else {
            currentPage = 0
        }
        collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentPage
    }
    
}

// MARK: Delegate && Datasource of ViewController

extension BannerCollectionReusableView: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trending.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8.0
        cell.getDataConfigure(image: trending[indexPath.row].image)
        self.collectionView.animateCell(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // navigation to play song here ....
        
    }
    
    //MARK: -Animation scroll view
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell {
            self.collectionView.animateCell(cell)
        }
    }
    
}
