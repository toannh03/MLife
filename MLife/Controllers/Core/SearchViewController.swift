//
//  SearchViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(ResultSearchTableViewCell.self, forCellReuseIdentifier: ResultSearchTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let results = ResultSearchViewController()
        let controller = UISearchController(searchResultsController: results)
        controller.searchBar.placeholder = "Songs"
        controller.searchBar.searchBarStyle = .minimal
        controller.definesPresentationContext = true
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()        
        title = "Search"
        navigationItem.searchController = searchController

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(searchTable)
//        
        searchTable.delegate = self
        searchTable.dataSource = self
        navigationController?.navigationBar.tintColor = .label
        searchController.searchResultsUpdater = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
        
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultSearchTableViewCell.identifier, for: indexPath) as? ResultSearchTableViewCell else { return UITableViewCell() }
//        let title = titles[indexPath.row]
//        let model = TitleViewModel(titleName: title.original_title ?? title.original_title ?? "Unknow name", posterURL: title.poster_path ?? "")
        
//        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar =  searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 2,
              let resultsController = searchController.searchResultsController as? ResultSearchViewController else { return }
        
        print(query)
        APISearch.shared.searchResults(with: query) {
            _ in 
//            DispatchQueue.main.async {
//                switch result {
//                    case .success(let titles):
//                        resultsController.titles = titles
//                        resultsController.searchResultCollectionView.reloadData()
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                }
//            }
        }
        
    }
    
    
}
