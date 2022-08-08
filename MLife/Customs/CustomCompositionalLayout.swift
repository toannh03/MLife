//
//  CustomCompositionalLayout.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 01/08/2022.
//

import UIKit

extension HomeViewController {
    
    static func createBasicCompositionLayout( widthItem: NSCollectionLayoutDimension,
                                              heightItem: NSCollectionLayoutDimension,
                                              top: CGFloat = 0,
                                              leading: CGFloat = 0,
                                              bottom: CGFloat = 0,
                                              trailing: CGFloat = 0,
                                              widthVertical: NSCollectionLayoutDimension? = nil,
                                              heightVertical: NSCollectionLayoutDimension? = nil,
                                              widthHorizotal: NSCollectionLayoutDimension? = nil,
                                              heightHorizotal: NSCollectionLayoutDimension? = nil,
                                              countVertical: Int = 1,
                                              countHorizotal: Int = 1,
                                              scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                              headerWidth: NSCollectionLayoutDimension? = nil,
                                              headerHeight: NSCollectionLayoutDimension? = nil
    ) -> NSCollectionLayoutSection? {
    
        let itemSize = NSCollectionLayoutSize(widthDimension: widthItem, heightDimension: heightItem)  
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize) 
                        
        item.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        
        if let widthHorizotal = widthHorizotal, let  heightHorizotal = heightHorizotal {
            
            let groupHorizotalSize = NSCollectionLayoutSize(widthDimension: widthHorizotal, heightDimension: heightHorizotal) 
            
            let groupHorizontal = NSCollectionLayoutGroup.horizontal(layoutSize: groupHorizotalSize, subitem: item, count: countHorizotal)
                        
            let section = NSCollectionLayoutSection(group: groupHorizontal)  
                                                
            if let headerWidth = headerWidth, let headerHeight = headerHeight {
                //MARK: - Supplementary Item
                let headerItemSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
            }
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)

            section.orthogonalScrollingBehavior = scrollBehavior
            
            return section
        }
        
        if let widthVertical = widthVertical , let heightVertical = heightVertical {
            
            let groupVerticalSize = NSCollectionLayoutSize(widthDimension: widthVertical, heightDimension: heightVertical) 
            
            let groupVertical = NSCollectionLayoutGroup.horizontal(layoutSize: groupVerticalSize, subitem: item, count: countHorizotal)
            
            let section = NSCollectionLayoutSection(group: groupVertical)  

            return section
        }
        
        return nil
        
    }
    
    static func createNestedGround( widthItem: NSCollectionLayoutDimension,
                                    heightItem: NSCollectionLayoutDimension,
                                    top: CGFloat = 0, leading: CGFloat = 0,
                                    bottom: CGFloat = 0, trailing: CGFloat = 0,
                                    widthVertical: NSCollectionLayoutDimension? = nil,
                                    heightVertical: NSCollectionLayoutDimension? = nil,
                                    widthHorizotal: NSCollectionLayoutDimension? = nil,
                                    heightHorizotal: NSCollectionLayoutDimension? = nil,
                                    countVertical: Int = 1,
                                    countHorizotal: Int = 1,
                                    headerWidth: NSCollectionLayoutDimension? = nil,
                                    headerHeight: NSCollectionLayoutDimension? = nil
    ) -> NSCollectionLayoutSection? {
        
        guard let widthVertical = widthVertical,
              let heightVertical = heightVertical,
              let widthHorizotal = widthHorizotal,
              let heightHorizotal = heightHorizotal
        else { return nil}
        
        let itemSize = NSCollectionLayoutSize(widthDimension: widthItem, heightDimension: heightItem)  
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)  
        
        item.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        
        let groupVeriticalSize = NSCollectionLayoutSize(widthDimension: widthVertical, heightDimension: heightVertical) 
        
        let groupVertical = NSCollectionLayoutGroup.vertical(layoutSize: groupVeriticalSize, subitem: item, count: countVertical)
        
        let groupHorizotalSize = NSCollectionLayoutSize(widthDimension: widthHorizotal, heightDimension: heightHorizotal) 
        
        let groupHorizontal = NSCollectionLayoutGroup.horizontal(layoutSize: groupHorizotalSize, subitem: groupVertical, count: countHorizotal)
        
        let section = NSCollectionLayoutSection(group: groupHorizontal)
        
        // Set default padding section = 13
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 11, bottom: 15, trailing: 11)

        if let headerWidth = headerWidth, let headerHeight = headerHeight {
                //MARK: - Supplementary Item
            let headerItemSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
        }
        
//        section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
}
