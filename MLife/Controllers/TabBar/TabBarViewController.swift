//
//  TabBarViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 15/07/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
                
        configureColorTabBarItem()
       
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let profileVC = ProfileViewController()
        
        let navigationHome = createTabBarController(view: homeVC, title: "For you", titleTabBar: "Home", imageTabBar: "house", imageTabBarSelected: "house.fill")
        let navigationSearch = createTabBarController(view: searchVC, title: "Search", titleTabBar: "Search", imageTabBar: "magnifyingglass", imageTabBarSelected: "text.magnifyingglass")
        let navigationProfile = createTabBarController(view: profileVC, title: "Profile", titleTabBar: "Me", imageTabBar: "person", imageTabBarSelected: "person.fill")
        
        setViewControllers([navigationHome, navigationSearch, navigationProfile], animated: true)
        
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let heightTabBar: CGFloat = view.frame.size.width / 7.0
//        
//        var tabFrame = self.tabBar.frame
//        // 55 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
//        tabFrame.size.height = heightTabBar
//        tabFrame.origin.y = self.view.frame.size.height - heightTabBar
//        self.tabBar.frame = tabFrame
        
    }
    
    // MARK: - Configure
    
    private func configureColorTabBarItem() {
        
        UITabBar.appearance().tintColor = .black
        // Make unselected icons white
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor(red:0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:0.2).cgColor
        tabBar.clipsToBounds = true
        
    }
    
    // MARK: - Create tab
    
    func createTabBarController(view: UIViewController, title: String, titleTabBar: String, imageTabBar: String, imageTabBarSelected: String? = nil ) -> UINavigationController {
        
        view.title = title
        view.navigationItem.largeTitleDisplayMode = .always
        
        let navigation = UINavigationController(rootViewController: view)
        navigation.navigationBar.tintColor = .label
        navigation.tabBarItem = UITabBarItem(title: titleTabBar , image: UIImage(systemName: imageTabBar ), selectedImage: UIImage(systemName: imageTabBarSelected ?? ""))
        
        navigation.navigationBar.prefersLargeTitles = true
        
        return navigation
        
    }
    
}
