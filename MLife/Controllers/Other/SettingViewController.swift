//
//  SettingViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 09/08/2022.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}


class SettingViewController: UIViewController {
    
    private var data = [[SettingCellModel]]()
    
    private var headerSection: [String] = ["General", "Display", "Others", ""]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped) 
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureMode()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureMode() {
        data.append([
            SettingCellModel(title: "View Profile") { [weak self] in 
                self?.didTapViewProfile()
            },
            SettingCellModel(title: "Invite Friends") { [weak self] in 
                self?.didTapInviteFriends()
            },  
            SettingCellModel(title: "Save Original Post") { [weak self] in 
                self?.didTapSaveOriginalPost()
            },
        ])
        
        data.append([
            SettingCellModel(title: "Appearance") { [weak self] in 
                self?.didTapViewProfile()
            },
            SettingCellModel(title: "Languages") { [weak self] in 
                self?.didTapInviteFriends()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Rate Us") { [weak self] in 
                self?.OpenURL(type: .terms)
            },
            SettingCellModel(title: "Help and support") { [weak self] in 
                self?.OpenURL(type: .privacy)
            },  
            SettingCellModel(title: "Feedback") { [weak self] in 
                self?.OpenURL(type: .help)
            },
            SettingCellModel(title: "Info") { [weak self] in 
                self?.OpenURL(type: .help)
            },
        ])
        data.append([
            SettingCellModel(title: "Log Out") { [weak self] in 
                self?.didTapLogOut()    
            }
        ])
    }
    
    
    public enum SettingURLType {
        case terms, privacy, help
    }
    
    private func OpenURL(type: SettingURLType) {
        let urlString: String
        switch type {
            case .terms: 
                urlString = ""
            case .privacy:
                urlString = ""
            case .help:
                urlString = ""
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapViewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
    }
    
    private func didTapInviteFriends() {
        
    }
    
    private func didTapSaveOriginalPost() {
        
    }
    
    private func didTapLogOut(){
        
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: {
                success in 
                DispatchQueue.main.async {
                    if success {
                            // log out success
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: true)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                            // error log out
                        fatalError("Could not log out user")
                        
                    }
                }
            })
            
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
        
    }
    


}


extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        cell.accessoryType = .disclosureIndicator

        if indexPath.section == 3 {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        }
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell seleting 
        data[indexPath.section][indexPath.row].handler()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerSection[section].uppercased()
    }
    
    
}
