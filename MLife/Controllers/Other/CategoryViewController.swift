//
//  CategoryViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 11/08/2022.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private let category: TopicResponse

    init(category: TopicResponse) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        print(category.categories)
        view.backgroundColor = .systemBackground

    }
    

}
