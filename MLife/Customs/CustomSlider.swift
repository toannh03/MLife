//
//  CustomSlider.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 24/08/2022.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let newThumb = super.thumbRect(forBounds: CGRect(x: 0, y: 0, width: 60, height: 20), trackRect: rect, value: value)
        return newThumb
    }
}
