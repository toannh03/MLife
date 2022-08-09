//
//  NotificationViewController.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 09/08/2022.
//

import UIKit

class NotificationViewController: UIViewController {
    
    private var loadingIndicator: UIActivityIndicatorView!
    private var alert: UIAlertController!
    
    private var imageCoverEmptyNotification: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "emptyNotification")
        imageView.isHidden = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 15, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = .gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        view.addSubview(imageCoverEmptyNotification)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
            self.alert.dismiss(animated: true, completion: nil)
            self.loadingIndicator.stopAnimating()
            self.imageCoverEmptyNotification.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        imageCoverEmptyNotification.frame = CGRect(x: view.frame.size.width / 2 - 100 , y: view.frame.size.height / 2 - 100, width: 200, height: 200)
    }
}
