//
//  CustomSlider.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 24/08/2022.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    var thumbTextLabel: UILabel = UILabel()
    
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbTextLabel.frame = thumbFrame
        thumbTextLabel.text = Double(value).description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
    }
}
