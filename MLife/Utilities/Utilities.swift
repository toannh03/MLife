//
//  Utilities.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 28/07/2022.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - Constraint anchor 
    
    func anchor(width: CGFloat? = nil, height: CGFloat? = nil, top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0.0, paddingBottom: CGFloat = 0.0, paddingLeft: CGFloat = 0.0, paddingRight: CGFloat = 0.0 ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    // MARK: - Set width + height
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    // MARK: - Set center
    
    func centerX(with view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if let topAnchor = topAnchor , let padding = paddingTop {
            self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }
    
    func centerY(withView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constraint: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constraint).isActive = true
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft!)
        }
    }  
    
    // MARK: - Set dimensions of width, height in UIView
    
    func setDimensions(height: CGFloat, width: CGFloat) { 
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
}

extension UIView {
    
    // MARK: - Create a UIView with color gradient
    
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.colors = [UIColor.white.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}


extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "YYYY-MM-dd"
        return date
    }()
    
    static let displayFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateStyle = .medium
        return date
    }()
}

extension String {
    static func formatedDate(string: String) -> String {
        let range = string.firstIndex(of: "T") ?? string.endIndex
        let subString = string[..<range]
        guard let date = DateFormatter.dateFormatter.date(from: String(subString)) else { return string }
        return DateFormatter.displayFormatter.string(from: date)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}



