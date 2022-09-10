//
//  ResultSearchViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 14/08/2022.
//

import UIKit
//import LNPopupController

//class ResultSearchViewController: UIViewController {
//    
//    lazy var resultSongs = [Song]()
//        
//    lazy var tableView: UITableView = {
//        let table = UITableView()
//        table.register(ResultSearchTableViewCell.self, forCellReuseIdentifier: ResultSearchTableViewCell.identifier)
//        table.backgroundColor = .systemCyan
//        return table 
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        print("show in song...")
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
//    
//}
//
//extension ResultSearchViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return resultSongs.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultSearchTableViewCell.identifier, for: indexPath) as? ResultSearchTableViewCell else {
//            return UITableViewCell()
//        }
//        let index = resultSongs[indexPath.row]
//        cell.getDataResultSearch(index)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let song = resultSongs[indexPath.row]
//        print("it is enter song...")
//        PlayerDataTransmission.shared.dataTransmission(SearchViewController(), likeSong: nil, song: song, playlists: nil)
//    }
//    
//}
