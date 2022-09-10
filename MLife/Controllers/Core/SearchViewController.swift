//
//  SearchViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    
    var resultSongs = [Song]()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(ResultSearchTableViewCell.self, forCellReuseIdentifier: ResultSearchTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
//        let results = ResultSearchViewController()
        let controller = UISearchController(searchResultsController: nil)
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
        searchTable.delegate = self
        searchTable.dataSource = self
        navigationController?.navigationBar.tintColor = .label
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !resultSongs.isEmpty {
            resultSongs = []
            self.searchTable.reloadData()
            searchController.automaticallyShowsCancelButton = true
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
        
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultSearchTableViewCell.identifier, for: indexPath) as? ResultSearchTableViewCell else { return UITableViewCell() }
        let model = resultSongs[indexPath.row]
        cell.getDataResultSearch(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = resultSongs[indexPath.row]
        searchController.hidesNavigationBarDuringPresentation = true
        PlayerDataTransmission.shared.dataTransmission(self, likeSong: nil, song: selectedSong, playlists: nil)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar =  searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 2 else { return }
        
        APISearch.shared.searchResults(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let songs):
                        self.resultSongs = songs
                        self.searchTable.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        
    }
    
}
