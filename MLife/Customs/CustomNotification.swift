//
//  CustomNotification.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 31/07/2022.
//

import Foundation
import NotificationBannerSwift

extension UIViewController {
    
    func floatingNotification( title: String? = nil,
                              subtitle: String? = nil,
                              titleFont: UIFont? = nil,
                              titleColor: UIColor? = nil,
                              titleTextAlign: NSTextAlignment? = nil,
                              subtitleFont: UIFont? = nil,
                              subtitleColor: UIColor? = nil,
                              subtitleTextAlign: NSTextAlignment? = nil,
                              leftView: UIView? = nil,
                              rightView: UIView? = nil,
                              style: BannerStyle = .info,
                              colors: BannerColorsProtocol? = nil,
                              iconPosition: GrowingNotificationBanner.IconPosition = .center
    ) {
        
        let notification = FloatingNotificationBanner( title: title,
                                                      subtitle: subtitle,
                                                      titleFont: titleFont,
                                                      titleColor: titleColor,
                                                      titleTextAlign: titleTextAlign,
                                                      subtitleFont: subtitleFont,
                                                      subtitleColor: subtitleColor,
                                                      subtitleTextAlign: subtitleTextAlign,
                                                      leftView: leftView,
                                                      rightView: rightView,
                                                      style: style,
                                                      colors: colors,
                                                      iconPosition: iconPosition
        )
        
        notification.show( bannerPosition: .bottom,
                          edgeInsets:  UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20),
                          cornerRadius: 13
        )
        
            // Change time dismiss of float notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            notification.dismiss()
        })
    }
    
}

